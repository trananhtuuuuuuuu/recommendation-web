package DATN.backend.security;

import java.nio.charset.StandardCharsets;
import java.time.Instant;
import java.util.Base64;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

@Service
public class JwtService {

    private static final String HMAC_ALGORITHM = "HmacSHA256";

    @Value("${app.jwt.secret:recommendation-website-secret-key}")
    private String secret;

    @Value("${app.jwt.expiration-minutes:60}")
    private long expirationMinutes;

    public String generateToken(InforInsideToken info) {
        long issuedAt = Instant.now().getEpochSecond();
        long expiresAt = Instant.now().plusSeconds(expirationMinutes * 60).getEpochSecond();
        String payload = info.getUserId() + "|" + info.getUserName() + "|" + info.getEmail() + "|"
                + info.getRoleName() + "|" + issuedAt + "|" + expiresAt;
        String encodedPayload = Base64.getUrlEncoder().withoutPadding()
                .encodeToString(payload.getBytes(StandardCharsets.UTF_8));
        return encodedPayload + "." + sign(encodedPayload);
    }

    public InforInsideToken parseToken(String token) {
        if (token == null || token.isBlank()) {
            throw new IllegalArgumentException("Token is required");
        }
        String[] parts = token.split("\\.");
        if (parts.length != 2) {
            throw new IllegalArgumentException("Invalid token format");
        }
        String payload = new String(Base64.getUrlDecoder().decode(parts[0]), StandardCharsets.UTF_8);
        if (!sign(parts[0]).equals(parts[1])) {
            throw new IllegalArgumentException("Invalid token signature");
        }
        String[] values = payload.split("\\|");
        if (values.length < 6) {
            throw new IllegalArgumentException("Invalid token payload");
        }
        long expiresAt = Long.parseLong(values[5]);
        if (Instant.now().getEpochSecond() > expiresAt) {
            throw new IllegalArgumentException("Token expired");
        }
        return new InforInsideToken(Long.parseLong(values[0]), values[1], values[2], values[3]);
    }

    private String sign(String content) {
        try {
            Mac mac = Mac.getInstance(HMAC_ALGORITHM);
            mac.init(new SecretKeySpec(secret.getBytes(StandardCharsets.UTF_8), HMAC_ALGORITHM));
            byte[] signature = mac.doFinal(content.getBytes(StandardCharsets.UTF_8));
            return Base64.getUrlEncoder().withoutPadding().encodeToString(signature);
        } catch (Exception exception) {
            throw new IllegalStateException("Unable to sign token", exception);
        }
    }
}