package DATN.backend.service.ImplService;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.client.SimpleClientHttpRequestFactory;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestClient;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestClientResponseException;
import org.springframework.web.client.ResourceAccessException;
import org.springframework.web.multipart.MultipartFile;

import DATN.backend.exception.AiServiceUnavailableException;
import DATN.backend.response.cv.CvAnalysisResponse;
import DATN.backend.response.cv.CvMatchAiResponse;
import DATN.backend.service.InterfaceService.InterfaceCvAiService;

/**
 * HTTP client for the LayoutLMv3 CV parsing service.
 */
@Service
public class ImplCvAiService implements InterfaceCvAiService {

    private static final Logger LOGGER = LoggerFactory.getLogger(ImplCvAiService.class);
    private static final long MAX_CV_BYTES = 15L * 1024L * 1024L;
    private static final List<String> ALLOWED_EXTENSIONS = List.of(
            ".pdf", ".doc", ".docx", ".png", ".jpg", ".jpeg", ".webp", ".bmp", ".tif", ".tiff");

    private final RestClient restClient;
    private final boolean enabled;

    /**
     * Creates the AI client from application configuration.
     *
     * @param baseUrl CV analysis service base URL
     * @param enabled whether CV analysis is enabled
     */
    public ImplCvAiService(
            @Value("${app.ai.base-url:http://localhost:8001}") String baseUrl,
            @Value("${app.ai.enabled:true}") boolean enabled) {
        this.restClient = RestClient.builder()
                .baseUrl(baseUrl)
                .requestFactory(new SimpleClientHttpRequestFactory())
                .build();
        this.enabled = enabled;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public CvAnalysisResponse analyzeCv(MultipartFile cvFile) {
        validateFile(cvFile);
        if (!enabled) {
            throw new AiServiceUnavailableException("Automatic CV analysis is currently disabled");
        }

        try {
            ByteArrayResource resource = new ByteArrayResource(cvFile.getBytes()) {
                @Override
                public String getFilename() {
                    return cvFile.getOriginalFilename() == null ? "cv" : cvFile.getOriginalFilename();
                }
            };
            MediaType fileMediaType = resolveMediaType(cvFile.getContentType());
            HttpHeaders fileHeaders = new HttpHeaders();
            fileHeaders.setContentType(fileMediaType);
            fileHeaders.setContentDispositionFormData("file", resource.getFilename());
            HttpEntity<ByteArrayResource> filePart = new HttpEntity<>(resource, fileHeaders);

            MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();
            body.add("file", filePart);

            CvAnalysisResponse response = restClient.post()
                    .uri("/parse-cv")
                    .contentType(MediaType.MULTIPART_FORM_DATA)
                    .body(body)
                    .retrieve()
                    .body(CvAnalysisResponse.class);
            if (response == null) {
                throw new AiServiceUnavailableException("The CV analysis service returned an empty response");
            }
            return response;
        } catch (RestClientResponseException exception) {
            LOGGER.warn(
                    "CV analysis service rejected the request with status {}: {}",
                    exception.getStatusCode(),
                    exception.getResponseBodyAsString());
            if (exception.getStatusCode().is4xxClientError()) {
                throw new IllegalArgumentException("The uploaded CV could not be analyzed");
            }
            throw new AiServiceUnavailableException("Automatic CV analysis is temporarily unavailable");
        } catch (ResourceAccessException | IOException exception) {
            throw new AiServiceUnavailableException("Automatic CV analysis is temporarily unavailable");
        } catch (RestClientException exception) {
            // Covers the AI worker closing the socket mid-response (e.g. a native
            // OCR crash): "Unexpected end of file from server". Degrade to a
            // friendly 503 instead of leaking a raw 500.
            LOGGER.warn("CV analysis service connection failed", exception);
            throw new AiServiceUnavailableException("Automatic CV analysis is temporarily unavailable");
        }
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public CvMatchAiResponse matchCvToJob(Map<String, Object> cv, Map<String, Object> jd, boolean llm, String method) {
        if (!enabled) {
            throw new AiServiceUnavailableException("CV matching is currently disabled");
        }

        Map<String, Object> options = new HashMap<>();
        options.put("llm", llm);
        if (method != null && !method.isBlank()) {
            options.put("method", method);
        }
        Map<String, Object> body = new HashMap<>();
        body.put("cv", cv);
        body.put("jd", jd);
        body.put("options", options);

        try {
            CvMatchAiResponse response = restClient.post()
                    .uri("/match")
                    .contentType(MediaType.APPLICATION_JSON)
                    .body(body)
                    .retrieve()
                    .body(CvMatchAiResponse.class);
            if (response == null) {
                throw new AiServiceUnavailableException("The CV matching service returned an empty response");
            }
            return response;
        } catch (RestClientResponseException exception) {
            LOGGER.warn(
                    "CV matching service rejected the request with status {}: {}",
                    exception.getStatusCode(),
                    exception.getResponseBodyAsString());
            if (exception.getStatusCode().is4xxClientError()) {
                throw new IllegalArgumentException("The CV could not be matched against the job description");
            }
            throw new AiServiceUnavailableException("CV matching is temporarily unavailable");
        } catch (ResourceAccessException exception) {
            throw new AiServiceUnavailableException("CV matching is temporarily unavailable");
        } catch (RestClientException exception) {
            LOGGER.warn("CV matching service connection failed", exception);
            throw new AiServiceUnavailableException("CV matching is temporarily unavailable");
        }
    }

    private void validateFile(MultipartFile cvFile) {
        if (cvFile == null || cvFile.isEmpty()) {
            throw new IllegalArgumentException("CV file is required");
        }
        if (cvFile.getSize() > MAX_CV_BYTES) {
            throw new IllegalArgumentException("CV file must not exceed 15 MB");
        }
        String fileName = cvFile.getOriginalFilename() == null ? "" : cvFile.getOriginalFilename().toLowerCase();
        if (ALLOWED_EXTENSIONS.stream().noneMatch(fileName::endsWith)) {
            throw new IllegalArgumentException("Unsupported CV file type");
        }
    }

    private MediaType resolveMediaType(String contentType) {
        if (contentType == null || contentType.isBlank()) {
            return MediaType.APPLICATION_OCTET_STREAM;
        }
        try {
            return MediaType.parseMediaType(contentType);
        } catch (IllegalArgumentException exception) {
            return MediaType.APPLICATION_OCTET_STREAM;
        }
    }
}
