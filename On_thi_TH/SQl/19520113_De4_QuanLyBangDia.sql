﻿CREATE DATABASE DE4_QuanLyBangDia
USE DE4_QuanLyBangDia

CREATE TABLE KHACHHANG
(
	MaKH CHAR(5) CONSTRAINT KH_MaKH_PK PRIMARY KEY,
	HoTen VARCHAR(30) NOT NULL,
	DiaChi VARCHAR(30),
	SoDT VARCHAR(15),
	LoaiKH VARCHAR(10)
)

CREATE TABLE BANG_DIA
(
	MaBD CHAR(5) CONSTRAINT BD_MaBD_PK PRIMARY KEY,
	TenBD VARCHAR(25) NOT NULL,
	TheLoai VARCHAR(25)
)

CREATE TABLE PHIEUTHUE
(
	MaPT CHAR(5) CONSTRAINT PT_MaPT_PK PRIMARY KEY,
	MaKH CHAR(5) CONSTRAINT PT_MaKH_FK FOREIGN KEY(MaKH)
		REFERENCES KHACHHANG(MaKH),
	NgayThue SMALLDATETIME,
	NgayTra SMALLDATETIME,
	Soluongthue INT
)

CREATE TABLE CHITIET_PM
(
	MaPT CHAR(5) CONSTRAINT CTPM_MaPT_FK FOREIGN KEY(MaPT)
		REFERENCES PHIEUTHUE(MaPT),
	MaBD CHAR(5) CONSTRAINT CTPM_MaBD_FK FOREIGN KEY(MaBD)
		REFERENCES BANG_DIA(MaBD)
	CONSTRAINT CTPM_MaPT_MaBD_PK PRIMARY KEY(MaPT, MaBD)
)

INSERT INTO BANGDIA VALUES('BD001','Bang dia A', 'Phim hanh dong')
INSERT INTO BANGDIA VALUES('BD002','Bang dia B', 'Phim tinh cam')
INSERT INTO BANGDIA VALUES('BD003','Bang dia C', 'Ca nhac')
INSERT INTO BANGDIA VALUES('BD004','Bang dia D', 'Phim hoat hinh')
INSERT INTO BANGDIA VALUES('BD005','Bang dia E', 'Ca nhac')
INSERT INTO BANGDIA VALUES('BD006','Bang dia F', 'Phim hanh dong')
INSERT INTO BANGDIA VALUES('BD007','Bang dia G', 'Ca nhac')
INSERT INTO BANGDIA VALUES('BD008','Bang dia H', 'Ca nhac')
INSERT INTO BANGDIA VALUES('BD009','Bang dia I', 'Phim tinh cam')
INSERT INTO BANGDIA VALUES('BD010','Bang dia J', 'Phim tinh cam')

INSERT INTO KHACHHANG VALUES('KH001', 'Khach hang A','Dia chi cua A', '0912345678','VIP')
INSERT INTO KHACHHANG VALUES('KH002', 'Khach hang B','Dia chi cua B', '0912345678','Member')
INSERT INTO KHACHHANG VALUES('KH003', 'Khach hang C','Dia chi cua C', '0912345678','VIP')
INSERT INTO KHACHHANG VALUES('KH004', 'Khach hang D','Dia chi cua D', '0912345678','Member')
INSERT INTO KHACHHANG VALUES('KH005', 'Khach hang E','Dia chi cua E', '0912345678','Member')
INSERT INTO KHACHHANG VALUES('KH006', 'Khach hang F','Dia chi cua F', '0912345678','Member')
INSERT INTO KHACHHANG VALUES('KH007', 'Khach hang G','Dia chi cua G', '0912345678','VIP')
INSERT INTO KHACHHANG VALUES('KH008', 'Khach hang H','Dia chi cua H', '0912345678','Member')
INSERT INTO KHACHHANG VALUES('KH009', 'Khach hang I','Dia chi cua I', '0912345678','VIP')
INSERT INTO KHACHHANG VALUES('KH010', 'Khach hang J','Dia chi cua J', '0912345678','VIP')

INSERT INTO PHIEUTHUE VALUES('PT001','KH001','1/5/2016','2/7/2016',6)
INSERT INTO PHIEUTHUE VALUES('PT002','KH002','1/5/2016','2/7/2016',2)
INSERT INTO PHIEUTHUE VALUES('PT003','KH003','1/5/2016','2/7/2016',12)
INSERT INTO PHIEUTHUE VALUES('PT004','KH004','1/5/2016','2/7/2016',3)
INSERT INTO PHIEUTHUE VALUES('PT005','KH005','1/5/2016','2/7/2016',4)
INSERT INTO PHIEUTHUE VALUES('PT006','KH005','1/5/2016','2/7/2016',4)
INSERT INTO PHIEUTHUE VALUES('PT007','KH005','1/5/2016','2/7/2016',2)
INSERT INTO PHIEUTHUE VALUES('PT008','KH005','1/5/2016','2/7/2016',4)
INSERT INTO PHIEUTHUE VALUES('PT009','KH009','1/5/2016','2/7/2016',15)
INSERT INTO PHIEUTHUE VALUES('PT010','KH010','1/5/2016','2/7/2016',20)

INSERT INTO CHITIET_PM VALUES('PT001','BD001')
INSERT INTO CHITIET_PM VALUES('PT002','BD002')
INSERT INTO CHITIET_PM VALUES('PT003','BD003')
INSERT INTO CHITIET_PM VALUES('PT004','BD004')
INSERT INTO CHITIET_PM VALUES('PT005','BD005')
INSERT INTO CHITIET_PM VALUES('PT006','BD006')
INSERT INTO CHITIET_PM VALUES('PT007','BD007')
INSERT INTO CHITIET_PM VALUES('PT008','BD008')
INSERT INTO CHITIET_PM VALUES('PT009','BD009')
INSERT INTO CHITIET_PM VALUES('PT010','BD010')

/*2.1. Thể loại băng đĩa chỉ thuộc các thể loại sau “ca nhạc”, “phim hành động”, “phim tình
cảm”, “phim hoạt hình”.*/
GO 
CREATE TRIGGER TRG_BANGDIA_TheLoai_INS_UPD ON BANG_DIA
FOR UPDATE, INSERT
AS
BEGIN
	DECLARE @TheLoai VARCHAR(25),
			@MaBD CHAR(5)

	SELECT @TheLoai = TheLoai, @MaBD = MaBD
	FROM INSERTED

	IF(@TheLoai NOT IN('Ca nhac','Phim hanh dong','Phim tinh cam','Phim hoat hinh'))
	BEGIN
		PRINT('LOI: THE LOAI BD PHAI THUOC CAC THE LOAI CA NHAC, PHIM HD, PHIM TINH CAM, PHIM HOAT HINH')
		ROLLBACK TRANSACTION
	END
END
--Kiểm tra Trigger
INSERT INTO BANG_DIA VALUES('BD001','Bang dia A', 'Phim kinh di') --Error

/*2.2. Chỉ những khách hàng thuộc loại VIP mới được thuê với số lượng băng đĩa trên 5.*/
GO
CREATE TRIGGER TRG_PHIEUTHUE_Soluongthue_MaKH_UPD_INS ON PHIEUTHUE
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @MaKH CHAR(5),
			@Soluongthue INT,
			@LoaiKH VARCHAR(25)

	SELECT @MaKH = MaKH, @Soluongthue = Soluongthue
	FROM INSERTED

	SELECT @LoaiKH = LoaiKH
	FROM KHACHHANG
	WHERE MaKH = @MaKH

	IF(@LoaiKH <> 'VIP' AND @Soluongthue > 5)
	BEGIN
		PRINT('LOI: CHI NHUNG KHACH HANG THUOC LOAI VIP MOI DUOC THEU SO BANG DIA TREN 5')
		ROLLBACK TRANSACTION
	END
END
--Kiểm tra Trigger
SELECT* FROM KHACHHANG
INSERT INTO PHIEUTHUE VALUES('PT144','KH002','1/5/2016','2/7/2016',6) --Error
UPDATE PHIEUTHUE
SET Soluongthue = 6 --Error
WHERE MaKH = 'KH002'

GO
CREATE TRIGGER TRG_KHACHHANG_LoaiKH_UPD ON KHACHHANG
FOR UPDATE
AS
BEGIN
	IF EXISTS(	SELECT*
				FROM PHIEUTHUE PT JOIN INSERTED KH ON PT.MaKH = KH.MaKH
				WHERE LoaiKH <> 'VIP' AND Soluongthue > 5)
	BEGIN
		PRINT('TRG_KHACHHANG_LoaiKH_UPD: CHI NHUNG KHACH HANG THUOC LOAI VIP MOI DUOC THEU SO BANG DIA TREN 5')
		ROLLBACK TRANSACTION
	END
END

drop trigger TRG_KHACHHANG_LoaiKH_UPD
--Kiểm tra Trigger
UPDATE KHACHHANG 
SET LoaiKH = 'Member' 
WHERE MaKH = 'KH001'

/*3.1 Tìm các khách hàng (MaDG,HoTen) đã thuê băng đĩa thuộc thể loại phim “Tình
cảm” có số lượng thuê lớn hơn 3.*/
SELECT KH.MaKH, HoTen
FROM ((KHACHHANG KH JOIN PHIEUTHUE PT ON PT.MaKH = KH.MaKH)
		JOIN CHITIET_PM CTPM ON CTPM.MaPT = PT.MaPT)
			JOIN BANGDIA BD ON BD.MaBD = CTPM.MaBD
WHERE TheLoai = 'Phim tinh cam' AND Soluongthue > 3

/*3.2 Tìm các khách hàng(MaDG,HoTen) thuộc loại VIP đã thuê nhiều băng đĩa nhất.*/
SELECT TOP 1 WITH TIES KH.MaKH, HoTen
FROM KHACHHANG KH JOIN PHIEUTHUE PT ON PT.MaKH = KH.MaKH
WHERE LoaiKH = 'VIP'
GROUP BY KH.MaKH, HoTen
ORDER BY SUM(Soluongthue) DESC

/*3.3 Trong mỗi thể loại băng đĩa, cho biết tên khách hàng nào đã thuê nhiều băng đĩa nhất.*/
SELECT TheLoai, HoTen
FROM ((KHACHHANG KH JOIN PHIEUTHUE PT ON PT.MaKH = KH.MaKH)
		JOIN CHITIET_PM CTPM ON CTPM.MaPT = PT.MaPT)
			JOIN BANGDIA BD1 ON BD1.MaBD = CTPM.MaBD
GROUP BY TheLoai, HoTen
HAVING SUM(Soluongthue) >= ALL(		SELECT SUM(Soluongthue)
									FROM ((KHACHHANG KH JOIN PHIEUTHUE PT ON PT.MaKH = KH.MaKH)
											JOIN CHITIET_PM CTPM ON CTPM.MaPT = PT.MaPT)
												JOIN BANGDIA BD2 ON BD2.MaBD = CTPM.MaBD
									GROUP BY TheLoai, HoTen
									HAVING BD1.TheLoai = BD2.TheLoai)
