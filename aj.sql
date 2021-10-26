-- phpMyAdmin SQL Dump
-- version 4.9.5
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 19, 2021 at 02:34 PM
-- Server version: 10.5.12-MariaDB-cll-lve
-- PHP Version: 7.2.34

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `u688585976_clothing`
--

-- --------------------------------------------------------

--
-- Table structure for table `cart`
--

CREATE TABLE `cart` (
  `customerID` int(6) NOT NULL,
  `productID` int(10) NOT NULL,
  `size` char(3) COLLATE utf8mb4_unicode_ci NOT NULL,
  `color` char(16) COLLATE utf8mb4_unicode_ci NOT NULL,
  `qty` int(6) NOT NULL,
  `price` double NOT NULL,
  `total` double NOT NULL,
  `date` date NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `category`
--

CREATE TABLE `category` (
  `categoryID` int(5) NOT NULL,
  `category` char(100) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `category`
--

INSERT INTO `category` (`categoryID`, `category`) VALUES
(0, 'All'),
(1, 'Men'),
(19, 'Baggy'),
(20, 'Skinny');

-- --------------------------------------------------------

--
-- Table structure for table `customer`
--

CREATE TABLE `customer` (
  `customerID` int(6) NOT NULL,
  `mobile` int(10) NOT NULL,
  `email` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `pass` char(8) COLLATE utf8mb4_unicode_ci NOT NULL,
  `city` char(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `district` char(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `address` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `customer`
--

INSERT INTO `customer` (`customerID`, `mobile`, `email`, `name`, `pass`, `city`, `district`, `address`) VALUES
(91, 776591828, 'thaksharadhananjaya@gmail.com', 'AJ Style', '12345678', 'Colombo', 'Colombo', 'No 1'),
(92, 771304324, 'ksm.nafran@gmail.com', 'ksm nafran', '143786.a', 'galle', 'Galle', '63/8 humes road '),
(93, 772658217, 'w.c.d.weerasinghe@gmail.com', '', '12345678', '', '', ''),
(95, 771304324, 'ksm.nafran@gmai.com', 'Nafran khan', '143786', 'Galle', 'Galle', '63/8,humes road , galle'),
(96, 753988070, 'Nawshadk9510@gmail.com', 'Nawshad khan ', '654321', 'Galle', 'Galle', '63/8 Humes road Galle '),
(99, 702308903, 'thaksharadhananjaya1@gmail.com', 'fy', '123456', 'tt', 'Galle', 'ff'),
(100, 776531828, 'thak@ff.com', 'dumindu', '123456', 'pallebedda', 'Ratnapura', 'koswetiya'),
(101, 755478634, 'nazrinasajad@gmail.com', 'nazrina ', '199saja4', 'Colombo', 'Colombo', 'manikkamulla '),
(102, 772560990, 'sajanimadukaliyanage@gmail.com', 'sajani', 'sajani', 'colimbo', 'Kalutara', '13/30sarvidaya road kasbewe');

-- --------------------------------------------------------

--
-- Table structure for table `order`
--

CREATE TABLE `order` (
  `orderID` int(7) UNSIGNED ZEROFILL NOT NULL,
  `customerID` int(6) NOT NULL,
  `total` double NOT NULL,
  `name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `address` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL,
  `city` char(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `district` char(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `mobile` int(10) NOT NULL,
  `date` date NOT NULL DEFAULT current_timestamp(),
  `status` int(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `orderProduct`
--

CREATE TABLE `orderProduct` (
  `orderID` int(10) NOT NULL,
  `productID` int(11) NOT NULL,
  `size` char(3) COLLATE utf8mb4_unicode_ci NOT NULL,
  `color` char(16) COLLATE utf8mb4_unicode_ci NOT NULL,
  `qty` int(5) NOT NULL,
  `price` double NOT NULL,
  `status` int(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `product`
--

CREATE TABLE `product` (
  `productID` int(11) NOT NULL,
  `categoryID` int(5) NOT NULL DEFAULT 1,
  `name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `price` float NOT NULL,
  `salePrice` double NOT NULL,
  `discription` varchar(400) COLLATE utf8mb4_unicode_ci NOT NULL,
  `image` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `product`
--

INSERT INTO `product` (`productID`, `categoryID`, `name`, `price`, `salePrice`, `discription`, `image`) VALUES
(146, 0, 'T Shirt', 1500, 1500, 'Sample', 'https://ajstyle.lk/uploads/T Shirt.jpg');

-- --------------------------------------------------------

--
-- Table structure for table `settings`
--

CREATE TABLE `settings` (
  `whatsapp` int(10) NOT NULL,
  `tearms` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL,
  `about` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `settings`
--

INSERT INTO `settings` (`whatsapp`, `tearms`, `about`) VALUES
(771304324, '', '');

-- --------------------------------------------------------

--
-- Table structure for table `sizeChart`
--

CREATE TABLE `sizeChart` (
  `productID` int(11) NOT NULL,
  `data` varchar(400) COLLATE utf8mb4_unicode_ci NOT NULL,
  `isLabel` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `userName` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` char(16) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`userName`, `password`) VALUES
('adajmin', 'aj98$#'),
('admin', 'a');

-- --------------------------------------------------------

--
-- Table structure for table `variant`
--

CREATE TABLE `variant` (
  `productID` int(10) NOT NULL,
  `color` char(16) COLLATE utf8mb4_unicode_ci NOT NULL,
  `size` char(3) COLLATE utf8mb4_unicode_ci NOT NULL,
  `qty` int(8) NOT NULL,
  `price` double NOT NULL,
  `salePrice` double NOT NULL,
  `image` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `variant`
--

INSERT INTO `variant` (`productID`, `color`, `size`, `qty`, `price`, `salePrice`, `image`) VALUES
(146, '0xffc84646', 'S', 10, 1500, 1500, 'https://ajstyle.lk/uploads/1460xffc84646S.jpg');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `cart`
--
ALTER TABLE `cart`
  ADD PRIMARY KEY (`customerID`,`productID`,`size`,`color`);

--
-- Indexes for table `category`
--
ALTER TABLE `category`
  ADD PRIMARY KEY (`categoryID`);

--
-- Indexes for table `customer`
--
ALTER TABLE `customer`
  ADD PRIMARY KEY (`customerID`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `order`
--
ALTER TABLE `order`
  ADD PRIMARY KEY (`orderID`);

--
-- Indexes for table `orderProduct`
--
ALTER TABLE `orderProduct`
  ADD PRIMARY KEY (`orderID`,`productID`,`size`,`color`);

--
-- Indexes for table `product`
--
ALTER TABLE `product`
  ADD PRIMARY KEY (`productID`);

--
-- Indexes for table `sizeChart`
--
ALTER TABLE `sizeChart`
  ADD PRIMARY KEY (`productID`,`data`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`userName`);

--
-- Indexes for table `variant`
--
ALTER TABLE `variant`
  ADD PRIMARY KEY (`productID`,`color`,`size`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `category`
--
ALTER TABLE `category`
  MODIFY `categoryID` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `customer`
--
ALTER TABLE `customer`
  MODIFY `customerID` int(6) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=103;

--
-- AUTO_INCREMENT for table `order`
--
ALTER TABLE `order`
  MODIFY `orderID` int(7) UNSIGNED ZEROFILL NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `product`
--
ALTER TABLE `product`
  MODIFY `productID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=147;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
