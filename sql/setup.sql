CREATE TABLE IF NOT EXISTS COLOR (
  ID int(10) unsigned NOT NULL AUTO_INCREMENT,
  `NAME` varchar(32) NOT NULL,
  PRIMARY KEY (ID),
  UNIQUE KEY `NAME` (`NAME`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=8 ;

INSERT INTO COLOR (ID, `NAME`) VALUES(1, 'RED');
INSERT INTO COLOR (ID, `NAME`) VALUES(2, 'ORANGE');
INSERT INTO COLOR (ID, `NAME`) VALUES(3, 'YELLOW');
INSERT INTO COLOR (ID, `NAME`) VALUES(4, 'GREEN');
INSERT INTO COLOR (ID, `NAME`) VALUES(5, 'BLUE');
INSERT INTO COLOR (ID, `NAME`) VALUES(6, 'INDIGO');
INSERT INTO COLOR (ID, `NAME`) VALUES(7, 'VIOLET');

CREATE TABLE IF NOT EXISTS FLAVOR (
  ID int(10) unsigned NOT NULL AUTO_INCREMENT,
  `NAME` varchar(32) NOT NULL,
  PRIMARY KEY (ID),
  UNIQUE KEY `NAME` (`NAME`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=5 ;

INSERT INTO FLAVOR (ID, `NAME`) VALUES(1, 'VANILLA');
INSERT INTO FLAVOR (ID, `NAME`) VALUES(2, 'CHOCOLATE');
INSERT INTO FLAVOR (ID, `NAME`) VALUES(3, 'STRAWBERRY');
INSERT INTO FLAVOR (ID, `NAME`) VALUES(4, 'COFFEE');

CREATE TABLE IF NOT EXISTS REALLY_BIG_TABLE (
  ID int(10) unsigned NOT NULL AUTO_INCREMENT,
  NAME_FIRST varchar(32) NOT NULL,
  NAME_MI char(1) DEFAULT NULL,
  NAME_LAST varchar(32) NOT NULL,
  ADDR_ST1 varchar(32) NOT NULL,
  ADDR_ST2 varchar(32) DEFAULT NULL,
  ADDR_CITY varchar(32) NOT NULL,
  ADDR_STATE varchar(2) DEFAULT NULL,
  ADDR_POSTCODE varchar(16) NOT NULL,
  ADDR_COUNTRY varchar(2) NOT NULL,
  ADDR_PHONE varchar(32) NOT NULL,
  ALT_ST1 varchar(32) NOT NULL,
  ALT_ST2 varchar(32) DEFAULT NULL,
  ALT_CITY varchar(32) NOT NULL,
  ALT_STATE varchar(2) DEFAULT NULL,
  ALT_POSTCODE varchar(16) NOT NULL,
  ALT_COUNTRY varchar(2) NOT NULL,
  ALT_PHONE varchar(32) NOT NULL,
  FAVORITE_COLOR int(10) unsigned NOT NULL,
  FAVORITE_FLAVOR int(10) unsigned NOT NULL,
  PRIMARY KEY (ID),
  KEY NAME_FIRST (NAME_FIRST,NAME_LAST,ADDR_CITY,ADDR_STATE,ADDR_POSTCODE,ADDR_COUNTRY,ADDR_PHONE,ALT_CITY,ALT_STATE,ALT_POSTCODE,ALT_COUNTRY,ALT_PHONE,FAVORITE_COLOR,FAVORITE_FLAVOR)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;
