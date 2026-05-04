package DATN.backend.model;

import java.sql.Date;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class BaseEntity {
    private Date createdAt;
    private Date updatedAt;
    private Date deletedAt;
    private Boolean isDeleted;

    BaseEntity(Date createdAt, Date updatedAt, Date deletedAt, Boolean isDeleted) {
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.deletedAt = deletedAt;
        this.isDeleted = isDeleted;
    }
}
