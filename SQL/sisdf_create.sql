-- MySQL Script generated by MySQL Workbench
-- Sex 31 Mar 2017 18:15:45 BRT
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema sisdf
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `sisdf` ;

-- -----------------------------------------------------
-- Schema sisdf
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `sisdf` DEFAULT CHARACTER SET utf8 ;
USE `sisdf` ;

-- -----------------------------------------------------
-- Table `sisdf`.`usuario`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sisdf`.`usuario` ;

CREATE TABLE IF NOT EXISTS `sisdf`.`usuario` (
  `id_usuario` INT NOT NULL AUTO_INCREMENT,
  `num_usp` INT(10) NOT NULL,
  `senha` VARCHAR(255) NOT NULL,
  `nome` VARCHAR(100) CHARACTER SET 'utf8' NOT NULL,
  `email` VARCHAR(60) CHARACTER SET 'utf8' NOT NULL,
  `ramal` VARCHAR(4) CHARACTER SET 'utf8' NULL DEFAULT NULL,
  `nivel_acesso` INT(1) NOT NULL,
  `ativo` INT(1) NULL DEFAULT NULL,
  PRIMARY KEY (`id_usuario`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC),
  UNIQUE INDEX `num_usp_UNIQUE` (`num_usp` ASC))
ENGINE = InnoDB
AUTO_INCREMENT = 1
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;


-- -----------------------------------------------------
-- Table `sisdf`.`sala`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sisdf`.`sala` ;

CREATE TABLE IF NOT EXISTS `sisdf`.`sala` (
  `id_sala` INT NOT NULL AUTO_INCREMENT,
  `num_sala` INT NOT NULL,
  `nome` VARCHAR(45) NULL,
  `ativo` TINYINT(1) NULL,
  PRIMARY KEY (`id_sala`),
  UNIQUE INDEX `num_sala_UNIQUE` (`num_sala` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;


-- -----------------------------------------------------
-- Table `sisdf`.`secao`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sisdf`.`secao` ;

CREATE TABLE IF NOT EXISTS `sisdf`.`secao` (
  `id_secao` INT NOT NULL AUTO_INCREMENT,
  `nome_secao` VARCHAR(45) NOT NULL,
  `icone` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_secao`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;


-- -----------------------------------------------------
-- Table `sisdf`.`finalidade`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sisdf`.`finalidade` ;

CREATE TABLE IF NOT EXISTS `sisdf`.`finalidade` (
  `id_finalidade` INT NOT NULL AUTO_INCREMENT,
  `descricao` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_finalidade`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;


-- -----------------------------------------------------
-- Table `sisdf`.`os_status`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sisdf`.`os_status` ;

CREATE TABLE IF NOT EXISTS `sisdf`.`os_status` (
  `id_status` INT NOT NULL AUTO_INCREMENT,
  `nome_status` VARCHAR(20) NOT NULL,
  `alias` VARCHAR(20) NOT NULL COMMENT 'Shortname para tarefas no sistema, como agrupamento e passagem para views',
  PRIMARY KEY (`id_status`),
  UNIQUE INDEX `alias_UNIQUE` (`alias` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;


-- -----------------------------------------------------
-- Table `sisdf`.`ordem_servico`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sisdf`.`ordem_servico` ;

CREATE TABLE IF NOT EXISTS `sisdf`.`ordem_servico` (
  `id_os` INT(11) NOT NULL AUTO_INCREMENT,
  `resumo` VARCHAR(100) NOT NULL,
  `descricao` VARCHAR(500) NOT NULL,
  `data_abertura` DATETIME NOT NULL,
  `data_fechamento` DATETIME NULL DEFAULT NULL,
  `last_update` DATETIME NOT NULL,
  `id_status_fk` INT NULL,
  `id_sala_fk` INT NOT NULL,
  `id_usuario_fk` INT(11) NOT NULL,
  `id_secao_fk` INT NOT NULL,
  `id_finalidade_fk` INT NOT NULL,
  PRIMARY KEY (`id_os`),
  INDEX `fk_ordem_servico_sala1_idx` (`id_sala_fk` ASC),
  INDEX `fk_ordem_servico_usuario1_idx` (`id_usuario_fk` ASC),
  INDEX `fk_ordem_servico_secao1_idx` (`id_secao_fk` ASC),
  INDEX `fk_ordem_servico_finalidade1_idx` (`id_finalidade_fk` ASC),
  INDEX `fk_ordem_servico_os_status1_idx` (`id_status_fk` ASC),
  CONSTRAINT `fk_ordem_servico_sala1`
    FOREIGN KEY (`id_sala_fk`)
    REFERENCES `sisdf`.`sala` (`id_sala`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_ordem_servico_usuario1`
    FOREIGN KEY (`id_usuario_fk`)
    REFERENCES `sisdf`.`usuario` (`id_usuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ordem_servico_secao1`
    FOREIGN KEY (`id_secao_fk`)
    REFERENCES `sisdf`.`secao` (`id_secao`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ordem_servico_finalidade1`
    FOREIGN KEY (`id_finalidade_fk`)
    REFERENCES `sisdf`.`finalidade` (`id_finalidade`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ordem_servico_os_status1`
    FOREIGN KEY (`id_status_fk`)
    REFERENCES `sisdf`.`os_status` (`id_status`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 3
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;


-- -----------------------------------------------------
-- Table `sisdf`.`material`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sisdf`.`material` ;

CREATE TABLE IF NOT EXISTS `sisdf`.`material` (
  `id_material` INT NOT NULL,
  `descricao` VARCHAR(255) NOT NULL,
  `forncecimento` VARCHAR(45) NULL,
  `id_os_fk` INT(11) NOT NULL,
  PRIMARY KEY (`id_material`, `id_os_fk`),
  INDEX `fk_material_ordem_servico1_idx` (`id_os_fk` ASC),
  CONSTRAINT `fk_material_ordem_servico1`
    FOREIGN KEY (`id_os_fk`)
    REFERENCES `sisdf`.`ordem_servico` (`id_os`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;


-- -----------------------------------------------------
-- Table `sisdf`.`membro`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sisdf`.`membro` ;

CREATE TABLE IF NOT EXISTS `sisdf`.`membro` (
  `id_secao_membros` INT NOT NULL,
  `id_usuario_membros` INT(11) NOT NULL,
  `cargo` INT(1) NOT NULL COMMENT '1 = Docente\n2 = Técnico',
  PRIMARY KEY (`id_secao_membros`, `id_usuario_membros`),
  INDEX `fk_membro_usuario1_idx` (`id_usuario_membros` ASC),
  CONSTRAINT `fk_membros_secao1`
    FOREIGN KEY (`id_secao_membros`)
    REFERENCES `sisdf`.`secao` (`id_secao`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_membro_usuario1`
    FOREIGN KEY (`id_usuario_membros`)
    REFERENCES `sisdf`.`usuario` (`id_usuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;


-- -----------------------------------------------------
-- Table `sisdf`.`anotacao`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sisdf`.`anotacao` ;

CREATE TABLE IF NOT EXISTS `sisdf`.`anotacao` (
  `id_anotacao` INT NOT NULL AUTO_INCREMENT,
  `data_anotacao` DATETIME NOT NULL,
  `texto` VARCHAR(1000) NOT NULL,
  `id_os_fk` INT(11) NOT NULL,
  `id_usuario_fk` INT(11) NOT NULL,
  PRIMARY KEY (`id_anotacao`, `id_os_fk`),
  INDEX `fk_anotacao_ordem_servico1_idx` (`id_os_fk` ASC),
  INDEX `fk_anotacao_usuario1_idx` (`id_usuario_fk` ASC),
  CONSTRAINT `fk_anotacao_ordem_servico1`
    FOREIGN KEY (`id_os_fk`)
    REFERENCES `sisdf`.`ordem_servico` (`id_os`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_anotacao_usuario1`
    FOREIGN KEY (`id_usuario_fk`)
    REFERENCES `sisdf`.`usuario` (`id_usuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;


-- -----------------------------------------------------
-- Table `sisdf`.`tipo_atendimento`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sisdf`.`tipo_atendimento` ;

CREATE TABLE IF NOT EXISTS `sisdf`.`tipo_atendimento` (
  `id_tipo_atendimento` INT NOT NULL AUTO_INCREMENT,
  `descricao` VARCHAR(45) NULL,
  PRIMARY KEY (`id_tipo_atendimento`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;


-- -----------------------------------------------------
-- Table `sisdf`.`os_informatica`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sisdf`.`os_informatica` ;

CREATE TABLE IF NOT EXISTS `sisdf`.`os_informatica` (
  `id_os_fk` INT(11) NOT NULL,
  `tipo_atendimento_fk` INT NOT NULL,
  PRIMARY KEY (`id_os_fk`, `tipo_atendimento_fk`),
  INDEX `fk_os_informatica_tipo_atendimento1_idx` (`tipo_atendimento_fk` ASC),
  CONSTRAINT `fk_os_informatica_ordem_servico1`
    FOREIGN KEY (`id_os_fk`)
    REFERENCES `sisdf`.`ordem_servico` (`id_os`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_os_informatica_tipo_atendimento1`
    FOREIGN KEY (`tipo_atendimento_fk`)
    REFERENCES `sisdf`.`tipo_atendimento` (`id_tipo_atendimento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_unicode_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
