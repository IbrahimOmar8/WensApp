package com.wens;

import static org.assertj.core.api.Assertions.assertThat;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.jdbc.core.JdbcTemplate;

@SpringBootTest(properties = {
        "spring.datasource.url=jdbc:h2:mem:migration;MODE=MySQL;DATABASE_TO_LOWER=TRUE",
        "spring.datasource.username=sa",
        "spring.datasource.password=",
        "spring.flyway.enabled=true",
        "spring.jpa.hibernate.ddl-auto=none"
})
class MigrationTest {

    @Autowired
    JdbcTemplate jdbc;

    @Test
    void schemaIsCreated() {
        Integer tables = jdbc.queryForObject(
                "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public' AND table_name IN "
                + "('users','patient_profile','care_link','device_token','emergency_contact','medication',"
                + "'schedule','dose_log','appointment','location_record','alert')", Integer.class);
        assertThat(tables).isEqualTo(11);
    }
}
