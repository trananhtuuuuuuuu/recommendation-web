package DATN.backend.utils;

import java.util.ArrayList;
import java.util.List;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.persistence.AttributeConverter;
import jakarta.persistence.Converter;

@Converter
public class StringListConverter implements AttributeConverter<List<String>, String> {

    private static final ObjectMapper OBJECT_MAPPER = new ObjectMapper();
    private static final TypeReference<List<String>> STRING_LIST_TYPE = new TypeReference<>() {
    };

    @Override
    public String convertToDatabaseColumn(List<String> attribute) {
        if (attribute == null) {
            return null;
        }
        try {
            return OBJECT_MAPPER.writeValueAsString(attribute);
        } catch (Exception exception) {
            return String.join("\n", attribute);
        }
    }

    @Override
    public List<String> convertToEntityAttribute(String dbData) {
        return fromString(dbData);
    }

    public static List<String> fromAny(Object value) {
        if (value == null) {
            return null;
        }
        if (value instanceof List<?> list) {
            return list.stream()
                    .filter(item -> item != null && !item.toString().isBlank())
                    .map(item -> item.toString().trim())
                    .toList();
        }
        return fromString(value.toString());
    }

    public static List<String> fromString(String value) {
        if (value == null || value.isBlank()) {
            return null;
        }
        try {
            List<String> parsed = OBJECT_MAPPER.readValue(value, STRING_LIST_TYPE);
            return parsed.stream()
                    .filter(item -> item != null && !item.isBlank())
                    .map(String::trim)
                    .toList();
        } catch (Exception exception) {
            List<String> out = new ArrayList<>();
            for (String part : value.split("[,;\\n|]")) {
                String trimmed = part.trim();
                if (!trimmed.isEmpty()) {
                    out.add(trimmed);
                }
            }
            return out;
        }
    }

    public static String join(List<String> values) {
        if (values == null || values.isEmpty()) {
            return null;
        }
        return String.join("\n", values);
    }
}
