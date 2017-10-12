
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE SCHEMA IF NOT EXISTS `pensions` DEFAULT CHARACTER SET utf8 ;
USE `pensions` ;

-- -----------------------------------------------------
-- Table `pensions`.`employees`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pensions`.`employees` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `empl_num` VARCHAR(45) NOT NULL,
  `dob` DATE NULL,
  `salary` DECIMAL NOT NULL,
  `employee_contr` DECIMAL NOT NULL,
  `employer_contr` DECIMAL NOT NULL,
  `role` VARCHAR(1) NOT NULL,
  `pass` VARCHAR(45) NOT NULL,
  `charity_id` INT NULL,
  `start_date` DATE NOT NULL,
  `annual_contr` DECIMAL NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `empl_num_UNIQUE` (`empl_num` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pensions`.`charities`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pensions`.`charities` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `address_line_1` VARCHAR(45) NOT NULL,
  `address_line_2` VARCHAR(45) NULL,
  `city` VARCHAR(45) NOT NULL,
  `postcode` VARCHAR(45) NULL,
  `country` VARCHAR(45) NOT NULL,
  `telephone` VARCHAR(45) NULL,
  `approved` INT NULL,
  `discarded` INT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pensions`.`process_history`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pensions`.`process_history` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `process_date` TIMESTAMP NOT NULL,
  `user_started` INT NOT NULL,
  `successful` TINYINT NOT NULL,
  `num_contr_added` INT NOT NULL,
  `type` VARCHAR(1) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `pensions`.`contributions`employees      
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pensions`.`contributions` (
  `id` INT NOT NULL  AUTO_INCREMENT,
  `type` VARCHAR(1) NOT NULL,
  `contr_pc` DECIMAL NULL,
  `contr_amount` DECIMAL NULL,
  `salary` DECIMAL NOT NULL,
  `process_date` TIMESTAMP NULL,
  `effective_date` TIMESTAMP NULL,
  `employees_id` INT NOT NULL,
  `charity_id` INT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_contributions_employees_idx` (`employees_id` ASC),
  INDEX `fk_contributions_charities1_idx` (`charity_id` ASC),
  CONSTRAINT `fk_contributions_employees`
    FOREIGN KEY (`employees_id`)
    REFERENCES `pensions`.`employees` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_contributions_charities1`
    FOREIGN KEY (`charity_id`)
    REFERENCES `pensions`.`charities` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
