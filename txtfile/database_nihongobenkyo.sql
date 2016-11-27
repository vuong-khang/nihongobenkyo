-- phpMyAdmin SQL Dump
-- version 4.0.4
-- http://www.phpmyadmin.net
--
-- ホスト: localhost
-- 生成日時: 2016 年 11 月 25 日 17:41
-- サーバのバージョン: 5.6.12-log
-- PHP のバージョン: 5.4.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- データベース: `nihongobenkyo`
--
CREATE DATABASE IF NOT EXISTS `nihongobenkyo` DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
USE `nihongobenkyo`;

DELIMITER $$
--
-- プロシージャ
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_sentaku_sakujyo`(
    IN para_index VARCHAR(20)
)
DELETE JISHO, MASU, TE, KAKO, HITEI, KANO, ISHI, JYOKEN, MEIREI, KINSHI, UKEMI, SHIEKI, SHIEKIUKEMI
FROM ma_jishokei JISHO

LEFT JOIN ma_masukei MASU
ON JISHO.index = MASU.index

LEFT JOIN ma_tekei TE
ON JISHO.index = TE.index

LEFT JOIN ma_kakokei KAKO
ON JISHO.index = KAKO.index

LEFT JOIN ma_hiteikei HITEI
ON JISHO.index = HITEI.index

LEFT JOIN ma_kanokei KANO
ON JISHO.index = KANO.index

LEFT JOIN ma_ishikei ISHI
ON JISHO.index = ISHI.index

LEFT JOIN ma_jyokenkei JYOKEN
ON JISHO.index = JYOKEN.index

LEFT JOIN ma_meireikei MEIREI
ON JISHO.index = MEIREI.index

LEFT JOIN ma_kinshikei KINSHI
ON JISHO.index = KINSHI.index

LEFT JOIN ma_ukemikei UKEMI
ON JISHO.index = UKEMI.index

LEFT JOIN ma_shiekikei SHIEKI
ON JISHO.index = SHIEKI.index

LEFT JOIN ma_shiekiukemikei SHIEKIUKEMI
ON JISHO.index = SHIEKIUKEMI.index

WHERE JISHO.index = para_index$$

DELIMITER ;

-- --------------------------------------------------------

--
-- テーブルの構造 `ma_hiteikei`
--

CREATE TABLE IF NOT EXISTS `ma_hiteikei` (
  `index` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  `kotoba_kj` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `kotoba_hira` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `dt_create` datetime DEFAULT NULL,
  `dt_update` datetime DEFAULT NULL,
  PRIMARY KEY (`index`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- テーブルの構造 `ma_ishikei`
--

CREATE TABLE IF NOT EXISTS `ma_ishikei` (
  `index` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  `kotoba_kj` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `kotoba_hira` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `dt_create` datetime DEFAULT NULL,
  `dt_update` datetime DEFAULT NULL,
  PRIMARY KEY (`index`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- テーブルの構造 `ma_jishokei`
--

CREATE TABLE IF NOT EXISTS `ma_jishokei` (
  `index` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  `kotoba_kj` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `kotoba_hira` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `group` tinyint(4) NOT NULL,
  `dt_create` datetime DEFAULT NULL,
  `dt_update` datetime DEFAULT NULL,
  PRIMARY KEY (`index`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- テーブルの構造 `ma_jyokenkei`
--

CREATE TABLE IF NOT EXISTS `ma_jyokenkei` (
  `index` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  `kotoba_kj` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `kotoba_hira` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `dt_create` datetime DEFAULT NULL,
  `dt_update` datetime DEFAULT NULL,
  PRIMARY KEY (`index`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- テーブルの構造 `ma_kakokei`
--

CREATE TABLE IF NOT EXISTS `ma_kakokei` (
  `index` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  `kotoba_kj` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `kotoba_hira` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `dt_create` datetime DEFAULT NULL,
  `dt_update` datetime DEFAULT NULL,
  PRIMARY KEY (`index`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- テーブルの構造 `ma_kanokei`
--

CREATE TABLE IF NOT EXISTS `ma_kanokei` (
  `index` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  `kotoba_kj` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `kotoba_hira` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `dt_create` datetime DEFAULT NULL,
  `dt_update` datetime DEFAULT NULL,
  PRIMARY KEY (`index`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- テーブルの構造 `ma_kinshikei`
--

CREATE TABLE IF NOT EXISTS `ma_kinshikei` (
  `index` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  `kotoba_kj` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `kotoba_hira` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `dt_create` datetime DEFAULT NULL,
  `dt_update` datetime DEFAULT NULL,
  PRIMARY KEY (`index`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- テーブルの構造 `ma_masukei`
--

CREATE TABLE IF NOT EXISTS `ma_masukei` (
  `index` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  `kotoba_kj` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `kotoba_hira` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `dt_create` datetime DEFAULT NULL,
  `dt_update` datetime DEFAULT NULL,
  PRIMARY KEY (`index`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- テーブルの構造 `ma_meireikei`
--

CREATE TABLE IF NOT EXISTS `ma_meireikei` (
  `index` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  `kotoba_kj` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `kotoba_hira` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `dt_create` datetime DEFAULT NULL,
  `dt_update` datetime DEFAULT NULL,
  PRIMARY KEY (`index`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- テーブルの構造 `ma_page`
--

CREATE TABLE IF NOT EXISTS `ma_page` (
  `id` int(11) NOT NULL,
  `header_jp` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `header_en` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `header_vi` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `title_jp` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `title_en` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `title_vi` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `icon` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `path` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- テーブルのデータのダンプ `ma_page`
--

INSERT INTO `ma_page` (`id`, `header_jp`, `header_en`, `header_vi`, `title_jp`, `title_en`, `title_vi`, `icon`, `path`, `parent_id`) VALUES
(0, 'ホーム', 'Home', 'Trang chủ', 'ホーム', 'Home', 'Trang chủ', 'fa-home', 'home_path', NULL),
(1, '言葉<br>検索', 'Search<br>vocabularies', 'Tìm<br>từ vựng', '言葉検索', 'Search vocabularies', 'Tìm từ vựng', 'fa-header', 'kotoba_path', NULL),
(2, '回数<br>読み', 'Read<br>numbers', 'Đọc<br>số', '回数読み', 'Read numbers', 'Đọc số', 'fa-usd', 'kaisuyomi_path', NULL),
(3, '言葉<br>編集', 'Edit<br>vocabularies', 'Chỉnh sửa<br>từ vựng', '言葉編集', 'Edit vocabularies', 'Chỉnh sửa từ vựng', NULL, 'kotoba_henshu_path', 1);

-- --------------------------------------------------------

--
-- テーブルの構造 `ma_shiekikei`
--

CREATE TABLE IF NOT EXISTS `ma_shiekikei` (
  `index` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  `kotoba_kj` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `kotoba_hira` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `dt_create` datetime DEFAULT NULL,
  `dt_update` datetime DEFAULT NULL,
  PRIMARY KEY (`index`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- テーブルの構造 `ma_shiekiukemikei`
--

CREATE TABLE IF NOT EXISTS `ma_shiekiukemikei` (
  `index` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  `kotoba_kj_1` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `kotoba_kj_2` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `kotoba_hira_1` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `kotoba_hira_2` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `dt_create` datetime DEFAULT NULL,
  `dt_update` datetime DEFAULT NULL,
  PRIMARY KEY (`index`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- テーブルの構造 `ma_tekei`
--

CREATE TABLE IF NOT EXISTS `ma_tekei` (
  `index` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  `kotoba_kj` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `kotoba_hira` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `dt_create` datetime DEFAULT NULL,
  `dt_update` datetime DEFAULT NULL,
  PRIMARY KEY (`index`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- テーブルの構造 `ma_ukemikei`
--

CREATE TABLE IF NOT EXISTS `ma_ukemikei` (
  `index` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  `kotoba_kj` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `kotoba_hira` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `dt_create` datetime DEFAULT NULL,
  `dt_update` datetime DEFAULT NULL,
  PRIMARY KEY (`index`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- ビュー用の代替構造 `vw_doshi`
--
CREATE TABLE IF NOT EXISTS `vw_doshi` (
`index` varchar(20)
,`jishokei` varchar(50)
,`yomikata` varchar(50)
,`group` tinyint(4)
,`masukei` varchar(50)
,`masukei_yomikata` varchar(50)
,`tekei` varchar(50)
,`tekei_yomikata` varchar(50)
,`kakokei` varchar(50)
,`kakokei_yomikata` varchar(50)
,`hiteikei` varchar(50)
,`hiteikei_yomikata` varchar(50)
,`kanokei` varchar(50)
,`kanokei_yomikata` varchar(50)
,`ishikei` varchar(50)
,`ishikei_yomikata` varchar(50)
,`jyokenkei` varchar(50)
,`jyokenkei_yomikata` varchar(50)
,`meireikei` varchar(50)
,`meireikei_yomikata` varchar(50)
,`kinshikei` varchar(50)
,`kinshikei_yomikata` varchar(50)
,`ukemikei` varchar(50)
,`ukemikei_yomikata` varchar(50)
,`shiekikei` varchar(50)
,`shiekikei_yomikata` varchar(50)
,`shiekiukemikei` varchar(103)
,`shiekiukemikei_yomikata` varchar(103)
,`dt_create` datetime
,`dt_update` datetime
);
-- --------------------------------------------------------

--
-- ビュー用の構造 `vw_doshi`
--
DROP TABLE IF EXISTS `vw_doshi`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_doshi` AS select `jisho`.`index` AS `index`,`jisho`.`kotoba_kj` AS `jishokei`,`jisho`.`kotoba_hira` AS `yomikata`,`jisho`.`group` AS `group`,`masu`.`kotoba_kj` AS `masukei`,`masu`.`kotoba_hira` AS `masukei_yomikata`,`te`.`kotoba_kj` AS `tekei`,`te`.`kotoba_hira` AS `tekei_yomikata`,`kako`.`kotoba_kj` AS `kakokei`,`kako`.`kotoba_hira` AS `kakokei_yomikata`,`hitei`.`kotoba_kj` AS `hiteikei`,`hitei`.`kotoba_hira` AS `hiteikei_yomikata`,`kano`.`kotoba_kj` AS `kanokei`,`kano`.`kotoba_hira` AS `kanokei_yomikata`,`ishi`.`kotoba_kj` AS `ishikei`,`ishi`.`kotoba_hira` AS `ishikei_yomikata`,`jyoken`.`kotoba_kj` AS `jyokenkei`,`jyoken`.`kotoba_hira` AS `jyokenkei_yomikata`,`meirei`.`kotoba_kj` AS `meireikei`,`meirei`.`kotoba_hira` AS `meireikei_yomikata`,`kinshi`.`kotoba_kj` AS `kinshikei`,`kinshi`.`kotoba_hira` AS `kinshikei_yomikata`,`ukemi`.`kotoba_kj` AS `ukemikei`,`ukemi`.`kotoba_hira` AS `ukemikei_yomikata`,`shieki`.`kotoba_kj` AS `shiekikei`,`shieki`.`kotoba_hira` AS `shiekikei_yomikata`,(case when ((`jisho`.`group` = 1) and (`shiekiukemi`.`kotoba_kj_1` is not null) and (length(`shiekiukemi`.`kotoba_kj_1`) > 0)) then concat(`shiekiukemi`.`kotoba_kj_1`,' / ',`shiekiukemi`.`kotoba_kj_2`) else `shiekiukemi`.`kotoba_kj_1` end) AS `shiekiukemikei`,(case when ((`jisho`.`group` = 1) and (`shiekiukemi`.`kotoba_hira_1` is not null) and (length(`shiekiukemi`.`kotoba_hira_1`) > 0)) then concat(`shiekiukemi`.`kotoba_hira_1`,' / ',`shiekiukemi`.`kotoba_hira_2`) else `shiekiukemi`.`kotoba_hira_1` end) AS `shiekiukemikei_yomikata`,`jisho`.`dt_create` AS `dt_create`,`jisho`.`dt_update` AS `dt_update` from ((((((((((((`ma_jishokei` `jisho` left join `ma_masukei` `masu` on((`jisho`.`index` = `masu`.`index`))) left join `ma_tekei` `te` on((`jisho`.`index` = `te`.`index`))) left join `ma_kakokei` `kako` on((`jisho`.`index` = `kako`.`index`))) left join `ma_hiteikei` `hitei` on((`jisho`.`index` = `hitei`.`index`))) left join `ma_kanokei` `kano` on((`jisho`.`index` = `kano`.`index`))) left join `ma_ishikei` `ishi` on((`jisho`.`index` = `ishi`.`index`))) left join `ma_jyokenkei` `jyoken` on((`jisho`.`index` = `jyoken`.`index`))) left join `ma_meireikei` `meirei` on((`jisho`.`index` = `meirei`.`index`))) left join `ma_kinshikei` `kinshi` on((`jisho`.`index` = `kinshi`.`index`))) left join `ma_ukemikei` `ukemi` on((`jisho`.`index` = `ukemi`.`index`))) left join `ma_shiekikei` `shieki` on((`jisho`.`index` = `shieki`.`index`))) left join `ma_shiekiukemikei` `shiekiukemi` on((`jisho`.`index` = `shiekiukemi`.`index`)));

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
