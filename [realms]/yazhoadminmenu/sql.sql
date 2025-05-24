CREATE TABLE `yazho_gradestaff` (
  `id` int(11) NOT NULL,
  `grade_name` text NOT NULL,
  `grade` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `yazho_gradestaff`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `yazho_gradestaff`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

CREATE TABLE `yazho_joueurstaff` (
  `id` int(11) NOT NULL,
  `steam` text NOT NULL,
  `name` text NOT NULL,
  `grade_name` text NOT NULL,
  `grade` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `yazho_joueurstaff`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `yazho_joueurstaff`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;
  
INSERT INTO yazho_joueurstaff (steam, name, grade_name, grade) VALUES
('steam:110000143b922f0', 'Yazho', 'Dev', '5');

INSERT INTO yazho_gradestaff (grade_name, grade) VALUES
('Dev', '5');

CREATE TABLE `yazho_kick` (
  `id` int(11) NOT NULL,
  `author` text NOT NULL,
  `date` text NOT NULL,
  `steam` text NOT NULL,
  `name` text NOT NULL,
  `reason` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `yazho_kick`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `yazho_kick`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

CREATE TABLE `yazho_warn` (
  `id` int(11) NOT NULL,
  `author` text NOT NULL,
  `date` text NOT NULL,
  `steam` text NOT NULL,
  `name` text NOT NULL,
  `reason` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `yazho_warn`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `yazho_warn`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;


CREATE TABLE `yazho_report` (
  `id` int(11) NOT NULL,
  `type` text NOT NULL,
  `author` text NOT NULL,
  `idjoueur` text NOT NULL,
  `date` text NOT NULL,
  `steam` text NOT NULL,
  `sujet` text NOT NULL,
  `desc` text NOT NULL,
  `status` text NOT NULL,
  `staff` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `yazho_report`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `yazho_report`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;

CREATE TABLE `yazho_banlist` (
  `id` int(11) AUTO_INCREMENT PRIMARY KEY,
  `license` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL,
  `identifier` varchar(25) COLLATE utf8mb4_bin DEFAULT NULL,
  `liveid` varchar(21) COLLATE utf8mb4_bin DEFAULT NULL,
  `xblid` varchar(21) COLLATE utf8mb4_bin DEFAULT NULL,
  `discord` varchar(30) COLLATE utf8mb4_bin DEFAULT NULL,
  `playerip` varchar(25) COLLATE utf8mb4_bin DEFAULT NULL,
  `targetplayername` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL,
  `sourceplayername` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL,
  `reason` varchar(255) NOT NULL,
  `timeat` varchar(255) NOT NULL,
  `expiration` varchar(255) NOT NULL,
  `added` varchar(255) NOT NULL,
  `tempsban` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `yazho_banlisthistory` (
  `id` int(11) AUTO_INCREMENT PRIMARY KEY,
  `license` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL,
  `identifier` varchar(25) COLLATE utf8mb4_bin DEFAULT NULL,
  `liveid` varchar(21) COLLATE utf8mb4_bin DEFAULT NULL,
  `xblid` varchar(21) COLLATE utf8mb4_bin DEFAULT NULL,
  `discord` varchar(30) COLLATE utf8mb4_bin DEFAULT NULL,
  `playerip` varchar(25) COLLATE utf8mb4_bin DEFAULT NULL,
  `targetplayername` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL,
  `sourceplayername` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL,
  `reason` varchar(255) NOT NULL,
  `timeat` int(255) NOT NULL,
  `added` varchar(255) NOT NULL,
  `expiration` int(255) NOT NULL,
  `tempsban` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `yazho_baninfo` (
  `id` int(11) AUTO_INCREMENT PRIMARY KEY,
  `license` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL,
  `identifier` varchar(25) COLLATE utf8mb4_bin DEFAULT NULL,
  `liveid` varchar(21) COLLATE utf8mb4_bin DEFAULT NULL,
  `xblid` varchar(21) COLLATE utf8mb4_bin DEFAULT NULL,
  `discord` varchar(30) COLLATE utf8mb4_bin DEFAULT NULL,
  `playerip` varchar(25) COLLATE utf8mb4_bin DEFAULT NULL,
  `playername` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;