-- Initial schema, based on the ERD in the SRS (section 6.6).

CREATE TABLE users (
    id            BIGINT AUTO_INCREMENT PRIMARY KEY,
    full_name     VARCHAR(100) NOT NULL,
    email         VARCHAR(150) NOT NULL UNIQUE,
    phone         VARCHAR(20),
    password_hash VARCHAR(100) NOT NULL,
    role          ENUM('CAREGIVER', 'PATIENT') NOT NULL,
    language      VARCHAR(2) NOT NULL DEFAULT 'en',
    created_at    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE patient_profile (
    id                BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id           BIGINT UNIQUE,
    full_name         VARCHAR(100) NOT NULL,
    date_of_birth     DATE,
    gender            VARCHAR(10),
    blood_type        VARCHAR(5),
    diagnosis         VARCHAR(255),
    allergies         VARCHAR(255),
    doctor_name       VARCHAR(100),
    doctor_phone      VARCHAR(20),
    notes             TEXT,
    invite_code       VARCHAR(6),
    invite_expires_at DATETIME,
    CONSTRAINT fk_profile_user FOREIGN KEY (user_id) REFERENCES users (id)
);

CREATE TABLE care_link (
    id           BIGINT AUTO_INCREMENT PRIMARY KEY,
    patient_id   BIGINT NOT NULL,
    caregiver_id BIGINT NOT NULL,
    linked_at    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_care_link UNIQUE (patient_id, caregiver_id),
    CONSTRAINT fk_link_patient FOREIGN KEY (patient_id) REFERENCES patient_profile (id),
    CONSTRAINT fk_link_caregiver FOREIGN KEY (caregiver_id) REFERENCES users (id)
);

CREATE TABLE device_token (
    id         BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id    BIGINT NOT NULL,
    fcm_token  VARCHAR(255) NOT NULL UNIQUE,
    platform   VARCHAR(20) NOT NULL DEFAULT 'ANDROID',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_device_user FOREIGN KEY (user_id) REFERENCES users (id)
);

CREATE TABLE emergency_contact (
    id           BIGINT AUTO_INCREMENT PRIMARY KEY,
    patient_id   BIGINT NOT NULL,
    name         VARCHAR(100) NOT NULL,
    phone        VARCHAR(20) NOT NULL,
    relationship VARCHAR(50),
    CONSTRAINT fk_contact_patient FOREIGN KEY (patient_id) REFERENCES patient_profile (id)
);

CREATE TABLE medication (
    id           BIGINT AUTO_INCREMENT PRIMARY KEY,
    patient_id   BIGINT NOT NULL,
    name         VARCHAR(100) NOT NULL,
    dosage       VARCHAR(100) NOT NULL,
    instructions VARCHAR(255),
    photo_url    VARCHAR(255),
    is_active    BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT fk_med_patient FOREIGN KEY (patient_id) REFERENCES patient_profile (id)
);

CREATE TABLE schedule (
    id           BIGINT AUTO_INCREMENT PRIMARY KEY,
    med_id       BIGINT NOT NULL,
    time_of_day  TIME NOT NULL,
    days_of_week VARCHAR(30) NOT NULL DEFAULT 'ALL',   -- 'ALL' or e.g. 'MON,WED,FRI'
    CONSTRAINT fk_schedule_med FOREIGN KEY (med_id) REFERENCES medication (id)
);

CREATE TABLE dose_log (
    id           BIGINT AUTO_INCREMENT PRIMARY KEY,
    schedule_id  BIGINT NOT NULL,
    action_by    BIGINT,
    scheduled_at DATETIME NOT NULL,
    status       ENUM('PENDING', 'TAKEN', 'SKIPPED', 'MISSED') NOT NULL DEFAULT 'PENDING',
    action_at    DATETIME,
    snooze_count INT NOT NULL DEFAULT 0,
    CONSTRAINT fk_dose_schedule FOREIGN KEY (schedule_id) REFERENCES schedule (id),
    CONSTRAINT fk_dose_user FOREIGN KEY (action_by) REFERENCES users (id)
);
CREATE INDEX idx_dose_status_time ON dose_log (status, scheduled_at);

CREATE TABLE appointment (
    id         BIGINT AUTO_INCREMENT PRIMARY KEY,
    patient_id BIGINT NOT NULL,
    title      VARCHAR(150) NOT NULL,
    date_time  DATETIME NOT NULL,
    place      VARCHAR(150),
    notes      VARCHAR(255),
    CONSTRAINT fk_appt_patient FOREIGN KEY (patient_id) REFERENCES patient_profile (id)
);

CREATE TABLE location_record (
    id            BIGINT AUTO_INCREMENT PRIMARY KEY,
    patient_id    BIGINT NOT NULL,
    latitude      DECIMAL(9, 6) NOT NULL,
    longitude     DECIMAL(9, 6) NOT NULL,
    battery_level INT,
    recorded_at   DATETIME NOT NULL,
    CONSTRAINT fk_location_patient FOREIGN KEY (patient_id) REFERENCES patient_profile (id)
);
CREATE INDEX idx_location_patient_time ON location_record (patient_id, recorded_at);

CREATE TABLE alert (
    id              BIGINT AUTO_INCREMENT PRIMARY KEY,
    patient_id      BIGINT NOT NULL,
    acknowledged_by BIGINT,
    type            ENUM('MISSED_DOSE', 'SOS') NOT NULL,
    status          ENUM('OPEN', 'ACKNOWLEDGED') NOT NULL DEFAULT 'OPEN',
    created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_alert_patient FOREIGN KEY (patient_id) REFERENCES patient_profile (id),
    CONSTRAINT fk_alert_user FOREIGN KEY (acknowledged_by) REFERENCES users (id)
);
