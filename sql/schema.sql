-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema ccinfom_dbapp_db
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema ccinfom_dbapp_db
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `ccinfom_dbapp_db` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `ccinfom_dbapp_db` ;

-- -----------------------------------------------------
-- Table `ccinfom_dbapp_db`.`cities`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ccinfom_dbapp_db`.`cities` (
  `city_code` VARCHAR(12) NOT NULL,
  `city_name` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`city_code`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `ccinfom_dbapp_db`.`barangays`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ccinfom_dbapp_db`.`barangays` (
  `brgy_code` VARCHAR(12) NOT NULL,
  `brgy_name` VARCHAR(100) NOT NULL,
  `city_code` VARCHAR(12) NOT NULL,
  PRIMARY KEY (`brgy_code`),
  INDEX `fk_barangay_city_idx` (`city_code` ASC) VISIBLE,
  CONSTRAINT `fk_barangay_city`
    FOREIGN KEY (`city_code`)
    REFERENCES `ccinfom_dbapp_db`.`cities` (`city_code`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `ccinfom_dbapp_db`.`locations`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ccinfom_dbapp_db`.`locations` (
  `location_id` INT NOT NULL,
  `address` VARCHAR(200) NOT NULL,
  `brgy_code` VARCHAR(12) NOT NULL,
  INDEX `fk_location_brgy_idx` (`brgy_code` ASC) VISIBLE,
  PRIMARY KEY (`location_id`),
  CONSTRAINT `fk_location_brgy`
    FOREIGN KEY (`brgy_code`)
    REFERENCES `ccinfom_dbapp_db`.`barangays` (`brgy_code`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `ccinfom_dbapp_db`.`patients`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ccinfom_dbapp_db`.`patients` (
  `pat_no` VARCHAR(20) NOT NULL,
  `last_name` VARCHAR(80) NOT NULL,
  `first_name` VARCHAR(100) NOT NULL,
  `middle_name` VARCHAR(80) NULL DEFAULT NULL,
  `birth_date` DATE NULL DEFAULT NULL,
  `sex` ENUM('Female', 'Male', 'Unknown') NOT NULL,
  `location_id` INT NOT NULL,
  `phone` VARCHAR(30) NULL DEFAULT NULL,
  `reg_date` DATE NOT NULL,
  PRIMARY KEY (`pat_no`),
  INDEX `fk_patient_location_idx` (`location_id` ASC) VISIBLE,
  CONSTRAINT `fk_patient_location`
    FOREIGN KEY (`location_id`)
    REFERENCES `ccinfom_dbapp_db`.`locations` (`location_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `ccinfom_dbapp_db`.`facilities`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ccinfom_dbapp_db`.`facilities` (
  `fac_no` VARCHAR(20) NOT NULL,
  `fac_name` VARCHAR(150) NOT NULL,
  `fac_type` ENUM('Hospital', 'Laboratory', 'HealthCenter') NOT NULL,
  `owner` ENUM('Public', 'Private', 'Nonprofit') NOT NULL,
  `location_id` INT NOT NULL,
  `contact` VARCHAR(120) NOT NULL,
  `phone` VARCHAR(30) NULL DEFAULT NULL,
  `reg_date` DATE NOT NULL,
  `fac_stat` ENUM('Active', 'Suspended', 'Closed') NOT NULL DEFAULT 'Active',
  PRIMARY KEY (`fac_no`),
  INDEX `fk_facility_location_idx` (`location_id` ASC) VISIBLE,
  CONSTRAINT `fk_facility_location`
    FOREIGN KEY (`location_id`)
    REFERENCES `ccinfom_dbapp_db`.`locations` (`location_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `ccinfom_dbapp_db`.`cases`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ccinfom_dbapp_db`.`cases` (
  `case_no` VARCHAR(24) NOT NULL,
  `pat_no` VARCHAR(20) NOT NULL,
  `fac_no` VARCHAR(20) NOT NULL,
  `local_ref` VARCHAR(60) NOT NULL,
  `disease` ENUM('Dengue', 'Measles', 'Leptospirosis', 'Cholera', 'Typhoid') NOT NULL,
  `onset_date` DATE NULL DEFAULT NULL,
  `reported_at` DATETIME NOT NULL,
  `class` ENUM('Suspected', 'Probable', 'Confirmed', 'Discarded') NOT NULL,
  `class_date` DATE NOT NULL,
  `status` ENUM('Open', 'UnderReview', 'Closed') NOT NULL DEFAULT 'Open',
  `outcome` ENUM('Unknown', 'Recovering', 'Recovered', 'Died') NOT NULL DEFAULT 'Unknown',
  `out_date` DATE NULL DEFAULT NULL,
  `location_id` INT NOT NULL,
  `remarks` VARCHAR(600) NULL DEFAULT NULL,
  PRIMARY KEY (`case_no`),
  UNIQUE INDEX `uq_facility_notification` (`fac_no` ASC, `local_ref` ASC) VISIBLE,
  INDEX `fk_case_patient` (`pat_no` ASC) VISIBLE,
  INDEX `fk_case_location_idx` (`location_id` ASC) VISIBLE,
  CONSTRAINT `fk_case_patient`
    FOREIGN KEY (`pat_no`)
    REFERENCES `ccinfom_dbapp_db`.`patients` (`pat_no`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_case_reporter`
    FOREIGN KEY (`fac_no`)
    REFERENCES `ccinfom_dbapp_db`.`facilities` (`fac_no`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_case_location`
    FOREIGN KEY (`location_id`)
    REFERENCES `ccinfom_dbapp_db`.`locations` (`location_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `ccinfom_dbapp_db`.`hospitals`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ccinfom_dbapp_db`.`hospitals` (
  `hosp_no` VARCHAR(20) NOT NULL,
  `bed_count` INT UNSIGNED NULL DEFAULT NULL,
  `emerg_svc` ENUM('Available', 'Unavailable', 'Unknown') NULL DEFAULT NULL,
  PRIMARY KEY (`hosp_no`),
  CONSTRAINT `fk_hospital_facility`
    FOREIGN KEY (`hosp_no`)
    REFERENCES `ccinfom_dbapp_db`.`facilities` (`fac_no`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `ccinfom_dbapp_db`.`admissions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ccinfom_dbapp_db`.`admissions` (
  `case_no` VARCHAR(24) NOT NULL,
  `adm_no` SMALLINT UNSIGNED NOT NULL,
  `hosp_no` VARCHAR(20) NOT NULL,
  `hosp_ref` VARCHAR(60) NOT NULL,
  `admitted_at` DATETIME NOT NULL,
  `discharge_at` DATETIME NULL DEFAULT NULL,
  `ward` VARCHAR(100) NOT NULL,
  `adm_stat` ENUM('Admitted', 'Discharged', 'Transferred', 'Died') NOT NULL,
  `remarks` VARCHAR(600) NULL DEFAULT NULL,
  PRIMARY KEY (`adm_no`, `case_no`),
  CONSTRAINT `fk_admission_case`
    FOREIGN KEY (`case_no`)
    REFERENCES `ccinfom_dbapp_db`.`cases` (`case_no`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_admission_hospital`
    FOREIGN KEY (`hosp_no`)
    REFERENCES `ccinfom_dbapp_db`.`hospitals` (`hosp_no`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `ccinfom_dbapp_db`.`followups`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ccinfom_dbapp_db`.`followups` (
  `case_no` VARCHAR(24) NOT NULL,
  `visit_no` SMALLINT UNSIGNED NOT NULL,
  `fac_no` VARCHAR(20) NOT NULL,
  `followup_at` DATETIME NOT NULL,
  `method` ENUM('Phone', 'HomeVisit', 'FacilityVisit') NOT NULL,
  `contact` ENUM('Reached', 'NotReached', 'Declined') NOT NULL,
  `finding` VARCHAR(600) NULL DEFAULT NULL,
  `next_date` DATE NULL DEFAULT NULL,
  `staff` VARCHAR(120) NOT NULL,
  `remarks` VARCHAR(600) NULL DEFAULT NULL,
  PRIMARY KEY (`case_no`, `visit_no`),
  INDEX `fk_followup_facility` (`fac_no` ASC) VISIBLE,
  CONSTRAINT `fk_followup_case`
    FOREIGN KEY (`case_no`)
    REFERENCES `ccinfom_dbapp_db`.`cases` (`case_no`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_followup_facility`
    FOREIGN KEY (`fac_no`)
    REFERENCES `ccinfom_dbapp_db`.`facilities` (`fac_no`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `ccinfom_dbapp_db`.`laboratories`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ccinfom_dbapp_db`.`laboratories` (
  `lab_no` VARCHAR(20) NOT NULL,
  `lab_lic` VARCHAR(60) NULL DEFAULT NULL,
  `biosafe` VARCHAR(60) NULL DEFAULT NULL,
  PRIMARY KEY (`lab_no`),
  CONSTRAINT `fk_laboratory_facility`
    FOREIGN KEY (`lab_no`)
    REFERENCES `ccinfom_dbapp_db`.`facilities` (`fac_no`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `ccinfom_dbapp_db`.`investigations`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ccinfom_dbapp_db`.`investigations` (
  `invest_id` INT NOT NULL,
  `invest_name` VARCHAR(60) NOT NULL,
  PRIMARY KEY (`invest_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `ccinfom_dbapp_db`.`labtests`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ccinfom_dbapp_db`.`labtests` (
  `case_no` VARCHAR(24) NOT NULL,
  `test_no` SMALLINT UNSIGNED NOT NULL,
  `lab_no` VARCHAR(20) NOT NULL,
  `lab_ref` VARCHAR(60) NOT NULL,
  `invest_id` INT NOT NULL,
  `specimen` ENUM('Blood', 'Serum', 'Stool', 'Urine', 'Swab') NOT NULL,
  `taken_at` DATETIME NULL DEFAULT NULL,
  `received_at` DATETIME NOT NULL,
  `result` ENUM('Pending', 'Positive', 'Negative', 'Inconclusive', 'Invalid') NOT NULL DEFAULT 'Pending',
  `result_at` DATETIME NULL DEFAULT NULL,
  `remarks` VARCHAR(600) NULL DEFAULT NULL,
  PRIMARY KEY (`case_no`, `test_no`),
  INDEX `fk_test_investigations_idx` (`invest_id` ASC) VISIBLE,
  CONSTRAINT `fk_test_case`
    FOREIGN KEY (`case_no`)
    REFERENCES `ccinfom_dbapp_db`.`cases` (`case_no`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_test_laboratory`
    FOREIGN KEY (`lab_no`)
    REFERENCES `ccinfom_dbapp_db`.`laboratories` (`lab_no`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_test_investigations`
    FOREIGN KEY (`invest_id`)
    REFERENCES `ccinfom_dbapp_db`.`investigations` (`invest_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `ccinfom_dbapp_db`.`healthcenters`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ccinfom_dbapp_db`.`healthcenters` (
  `hc_no` VARCHAR(20) NOT NULL,
  `catch_pop` INT UNSIGNED NULL DEFAULT NULL,
  `rhu_no` VARCHAR(30) NULL DEFAULT NULL,
  PRIMARY KEY (`hc_no`),
  CONSTRAINT `fk_hc_facility`
    FOREIGN KEY (`hc_no`)
    REFERENCES `ccinfom_dbapp_db`.`facilities` (`fac_no`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
