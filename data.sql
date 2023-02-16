-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`Alumni_Home_Page`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Alumni_Home_Page` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Alumni_Home_Page` (
  `netword_id` INT NOT NULL,
  `major_highlights` VARCHAR(45) NULL,
  `courses` VARCHAR(45) NULL,
  `success_stories` VARCHAR(45) NULL,
  `statistics` VARCHAR(45) NULL,
  PRIMARY KEY (`netword_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`join_user_registration`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`join_user_registration` ;

CREATE TABLE IF NOT EXISTS `mydb`.`join_user_registration` (
  `user_id` VARCHAR(45) NOT NULL,
  `Alumni_Home_Page_netword_id` INT NOT NULL,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `user_email` VARCHAR(45) NOT NULL,
  `user_name` VARCHAR(15) NOT NULL,
  PRIMARY KEY (`user_id`),
  INDEX `fk_user_registration_Alumni_Home_Page_idx` (`Alumni_Home_Page_netword_id` ASC) VISIBLE,
  CONSTRAINT `fk_user_registration_Alumni_Home_Page`
    FOREIGN KEY (`Alumni_Home_Page_netword_id`)
    REFERENCES `mydb`.`Alumni_Home_Page` (`netword_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Blogs`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Blogs` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Blogs` (
  `blog_id` INT NOT NULL AUTO_INCREMENT,
  `Alumni_Home_Page_netword_id` INT NOT NULL,
  `blog_details` VARCHAR(45) NULL,
  PRIMARY KEY (`blog_id`, `Alumni_Home_Page_netword_id`),
  INDEX `fk_Blogs_Alumni_Home_Page1_idx` (`Alumni_Home_Page_netword_id` ASC) VISIBLE,
  CONSTRAINT `fk_Blogs_Alumni_Home_Page1`
    FOREIGN KEY (`Alumni_Home_Page_netword_id`)
    REFERENCES `mydb`.`Alumni_Home_Page` (`netword_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`blog Entries`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`blog Entries` ;

CREATE TABLE IF NOT EXISTS `mydb`.`blog Entries` (
  `entry_id` INT NOT NULL,
  `Blogs_blog_id` INT NOT NULL,
  `author_first_name` VARCHAR(45) NULL,
  `author_last_name` VARCHAR(45) NULL,
  PRIMARY KEY (`entry_id`, `Blogs_blog_id`),
  INDEX `fk_blog Entries_Blogs1_idx` (`Blogs_blog_id` ASC) VISIBLE,
  CONSTRAINT `fk_blog Entries_Blogs1`
    FOREIGN KEY (`Blogs_blog_id`)
    REFERENCES `mydb`.`Blogs` (`blog_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Events`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Events` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Events` (
  `event_id` INT NOT NULL AUTO_INCREMENT,
  `Alumni_Home_Page_netword_id` INT NOT NULL,
  `past_event` VARCHAR(45) NULL,
  `upcoming_event` VARCHAR(45) NULL,
  PRIMARY KEY (`event_id`, `Alumni_Home_Page_netword_id`),
  INDEX `fk_Events_Alumni_Home_Page1_idx` (`Alumni_Home_Page_netword_id` ASC) VISIBLE,
  CONSTRAINT `fk_Events_Alumni_Home_Page1`
    FOREIGN KEY (`Alumni_Home_Page_netword_id`)
    REFERENCES `mydb`.`Alumni_Home_Page` (`netword_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Contact`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Contact` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Contact` (
  `contact_id` INT NOT NULL AUTO_INCREMENT,
  `Alumni_Home_Page_netword_id` INT NOT NULL,
  `first_name` VARCHAR(45) NULL,
  `last_name` VARCHAR(45) NULL,
  PRIMARY KEY (`contact_id`, `Alumni_Home_Page_netword_id`),
  INDEX `fk_Contact_Alumni_Home_Page1_idx` (`Alumni_Home_Page_netword_id` ASC) VISIBLE,
  CONSTRAINT `fk_Contact_Alumni_Home_Page1`
    FOREIGN KEY (`Alumni_Home_Page_netword_id`)
    REFERENCES `mydb`.`Alumni_Home_Page` (`netword_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Login/update`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Login/update` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Login/update` (
  `profile_id` INT NOT NULL,
  `Alumni_Home_Page_netword_id` INT NOT NULL,
  `user_id` VARCHAR(45) NOT NULL,
  `menber_contact_details` VARCHAR(45) NULL,
  PRIMARY KEY (`profile_id`, `user_id`),
  INDEX `fk_Login/update_Alumni_Home_Page1_idx` (`Alumni_Home_Page_netword_id` ASC) VISIBLE,
  INDEX `fk_Login/update_user_registration1_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `fk_Login/update_Alumni_Home_Page1`
    FOREIGN KEY (`Alumni_Home_Page_netword_id`)
    REFERENCES `mydb`.`Alumni_Home_Page` (`netword_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Login/update_user_registration1`
    FOREIGN KEY (`user_id`)
    REFERENCES `mydb`.`join_user_registration` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- Data for table `mydb`.`Alumni_Home_Page`
-- -----------------------------------------------------
START TRANSACTION;
USE `mydb`;
INSERT INTO `mydb`.`Alumni_Home_Page` (`netword_id`, `major_highlights`, `courses`, `success_stories`, `statistics`) VALUES (245689, NULL, NULL, NULL, NULL);

COMMIT;


-- -----------------------------------------------------
-- Data for table `mydb`.`Blogs`
-- -----------------------------------------------------
START TRANSACTION;
USE `mydb`;
INSERT INTO `mydb`.`Blogs` (`blog_id`, `Alumni_Home_Page_netword_id`, `blog_details`) VALUES (1, 245689, 'resume building');
INSERT INTO `mydb`.`Blogs` (`blog_id`, `Alumni_Home_Page_netword_id`, `blog_details`) VALUES (2, 245689, 'interview help');
INSERT INTO `mydb`.`Blogs` (`blog_id`, `Alumni_Home_Page_netword_id`, `blog_details`) VALUES (3, 245689, 'self promotion');
INSERT INTO `mydb`.`Blogs` (`blog_id`, `Alumni_Home_Page_netword_id`, `blog_details`) VALUES (4, 245689, 'working from home');
INSERT INTO `mydb`.`Blogs` (`blog_id`, `Alumni_Home_Page_netword_id`, `blog_details`) VALUES (5, 245689, 'self help');

COMMIT;


-- -----------------------------------------------------
-- Data for table `mydb`.`blog Entries`
-- -----------------------------------------------------
START TRANSACTION;
USE `mydb`;
INSERT INTO `mydb`.`blog Entries` (`entry_id`, `Blogs_blog_id`, `author_first_name`, `author_last_name`) VALUES (1, 1, 'Kyle', 'Ruthe');
INSERT INTO `mydb`.`blog Entries` (`entry_id`, `Blogs_blog_id`, `author_first_name`, `author_last_name`) VALUES (2, 2, 'Tyler', 'Wilders');
INSERT INTO `mydb`.`blog Entries` (`entry_id`, `Blogs_blog_id`, `author_first_name`, `author_last_name`) VALUES (3, 3, 'Brett', 'McDonald');
INSERT INTO `mydb`.`blog Entries` (`entry_id`, `Blogs_blog_id`, `author_first_name`, `author_last_name`) VALUES (4, 4, 'Jessie', 'Willmen');
INSERT INTO `mydb`.`blog Entries` (`entry_id`, `Blogs_blog_id`, `author_first_name`, `author_last_name`) VALUES (5, 5, 'Craig', 'Anderson');

COMMIT;


-- -----------------------------------------------------
-- Data for table `mydb`.`Events`
-- -----------------------------------------------------
START TRANSACTION;
USE `mydb`;
INSERT INTO `mydb`.`Events` (`event_id`, `Alumni_Home_Page_netword_id`, `past_event`, `upcoming_event`) VALUES (1, 245689, 'charity drive', NULL);
INSERT INTO `mydb`.`Events` (`event_id`, `Alumni_Home_Page_netword_id`, `past_event`, `upcoming_event`) VALUES (2, 245689, 'job fair', NULL);
INSERT INTO `mydb`.`Events` (`event_id`, `Alumni_Home_Page_netword_id`, `past_event`, `upcoming_event`) VALUES (3, 245689, 'masterclass', NULL);
INSERT INTO `mydb`.`Events` (`event_id`, `Alumni_Home_Page_netword_id`, `past_event`, `upcoming_event`) VALUES (4, 245689, NULL, 'resume help');
INSERT INTO `mydb`.`Events` (`event_id`, `Alumni_Home_Page_netword_id`, `past_event`, `upcoming_event`) VALUES (5, 245689, NULL, 'christmas event');

COMMIT;

