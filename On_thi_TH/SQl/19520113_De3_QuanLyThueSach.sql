﻿CREATE DATABASE DE3_QuanLyThueSach
USE QlyThueSach 

CREATE TABLE DOCGIA
(
	MaDG CHAR(5) CONSTRAINT DG_MaDG_PK PRIMARY KEY,
	HoTen VARCHAR(30) NOT NULL,
	NgSinh SMALLDATETIME,
	DiaChi VARCHAR(30),
	SoDT VARCHAR(15)
)

CREATE TABLE SACH
(
	MaSach CHAR(5) CONSTRAINT S_MaSach_PK PRIMARY KEY,
	TenSach VARCHAR(25) NOT NULL,
	TheLoai VARCHAR(25),
	NhaXuatBan VARCHAR(30)
)

CREATE TABLE PHIEUTHUE
(
	MaPT CHAR(5) CONSTRAINT PT_MaPT_PK PRIMARY KEY,
	MaDG CHAR(5) NOT NULL,
	NgayThue SMALLDATETIME,
	NgayTra SMALLDATETIME,
	SoSachThue INT
)

CREATE TABLE CHITIET_PT
(
	MaPT CHAR(5) CONSTRAINT CT_PT_MaPT_FK FOREIGN KEY(MaPT)
			REFERENCES PHIEUTHUE(MaPT),
	MaSach CHAR(5) CONSTRAINT CT_PT_MaSach_FK FOREIGN KEY(MaSach)
			REFERENCES SACH(MaSach), 
	CONSTRAINT CT_PT_MaPT_MaSach_PK PRIMARY KEY(MaPT, MaSach)
)

ALTER TABLE PHIEUTHUE ADD CONSTRAINT PHIEUTHUE_MaDG_FK FOREIGN KEY(MaDG)
		REFERENCES DOCGIA(MaDG)

INSERT INTO DOCGIA VALUES('DG001','Doc gia A', '1/12/1986','Dia chi A','0912345678')
INSERT INTO DOCGIA VALUES('DG002','Doc gia B', '2/12/1986','Dia chi B','0912345678')
INSERT INTO DOCGIA VALUES('DG003','Doc gia C', '3/12/1986','Dia chi C','0912345678')
INSERT INTO DOCGIA VALUES('DG004','Doc gia D', '4/12/1986','Dia chi D','0912345678')
INSERT INTO DOCGIA VALUES('DG005','Doc gia E', '5/12/1986','Dia chi E','0912345678')
INSERT INTO DOCGIA VALUES('DG006','Doc gia F', '6/12/1986','Dia chi F','0912345678')
INSERT INTO DOCGIA VALUES('DG007','Doc gia G', '7/12/1986','Dia chi G','0912345678')
INSERT INTO DOCGIA VALUES('DG008','Doc gia H', '8/12/1986','Dia chi H','0912345678')
INSERT INTO DOCGIA VALUES('DG009','Doc gia I', '9/12/1986','Dia chi I','0912345678')
INSERT INTO DOCGIA VALUES('DG010','Doc gia J', '10/12/1986','Dia chi J','0912345678')

INSERT INTO SACH VALUES('S0001','Sach A','Tin hoc','Tre')
INSERT INTO SACH VALUES('S0002','Sach B','Tin hoc','Giao duc')
INSERT INTO SACH VALUES('S0003','Sach C','Tin hoc','Tre')
INSERT INTO SACH VALUES('S0004','Sach D','Tin hoc','Giao duc')
INSERT INTO SACH VALUES('S0005','Sach E','Tin hoc','Tre')
INSERT INTO SACH VALUES('S0006','Sach F','Van hoc','Giao duc')
INSERT INTO SACH VALUES('S0007','Sach G','Van hoc','Giao duc')
INSERT INTO SACH VALUES('S0008','Sach H','Van hoc','Tre')
INSERT INTO SACH VALUES('S0009','Sach I','Toan hoc','Giao duc')
INSERT INTO SACH VALUES('S0010','Sach J','Toan hoc','Tre')

INSERT INTO PHIEUTHUE VALUES('PT001','DG001','1/4/2019','1/5/2019',5)
INSERT INTO PHIEUTHUE VALUES('PT002','DG002','1/4/2010','1/5/2010',5)
INSERT INTO PHIEUTHUE VALUES('PT003','DG003','1/4/2007','1/5/2007',15)
INSERT INTO PHIEUTHUE VALUES('PT004','DG004','1/4/2019','1/5/2019',5)
INSERT INTO PHIEUTHUE VALUES('PT005','DG005','1/4/2019','1/5/2019',4)
INSERT INTO PHIEUTHUE VALUES('PT006','DG006','1/4/2007','1/5/2007',5)
INSERT INTO PHIEUTHUE VALUES('PT007','DG007','1/4/2019','1/5/2019',3)
INSERT INTO PHIEUTHUE VALUES('PT008','DG008','1/4/2007','1/5/2007',1)
INSERT INTO PHIEUTHUE VALUES('PT009','DG009','1/4/2007','1/5/2007',10)
INSERT INTO PHIEUTHUE VALUES('PT010','DG010','1/4/2007','1/5/2007',5)

INSERT INTO CHITIET_PT VALUES('PT001', 'S0001')
INSERT INTO CHITIET_PT VALUES('PT002', 'S0002')
INSERT INTO CHITIET_PT VALUES('PT003', 'S0003')
INSERT INTO CHITIET_PT VALUES('PT004', 'S0004')
INSERT INTO CHITIET_PT VALUES('PT005', 'S0005')
INSERT INTO CHITIET_PT VALUES('PT006', 'S0006')
INSERT INTO CHITIET_PT VALUES('PT007', 'S0007')
INSERT INTO CHITIET_PT VALUES('PT008', 'S0008')
INSERT INTO CHITIET_PT VALUES('PT009', 'S0009')
INSERT INTO CHITIET_PT VALUES('PT010', 'S0010')
INSERT INTO CHITIET_PT VALUES('PT010', 'S0001')
INSERT INTO CHITIET_PT VALUES('PT010', 'S0002')
INSERT INTO CHITIET_PT VALUES('PT009', 'S0010')
INSERT INTO CHITIET_PT VALUES('PT008', 'S0010')
INSERT INTO CHITIET_PT VALUES('PT007', 'S0010')
INSERT INTO CHITIET_PT VALUES('PT007', 'S0006')

/*2.1. Mỗi lần thuê sách, độc giả không được thuê quá 10 ngày.*/
GO
CREATE TRIGGER TRG_PHIEUTHUE_THEMSUA_NgayThue_NgayTra ON PHIEUTHUE
FOR UPDATE, INSERT
AS
BEGIN
	DECLARE @NgayThue SMALLDATETIME,
			@NgayTra SMALLDATETIME

	SELECT @NgayThue = NgayThue, @NgayTra = NgayTra
	FROM INSERTED

	IF(DATEDIFF(day, @NgayThue, @NgayTra) > 10)
	BEGIN
		PRINT 'LOI: DOC GIA KHONG DUOC THUE QUA 10 NGAY'
		ROLLBACK TRANSACTION
	END
END
--Kiểm tra Trigger
SET DATEFORMAT DMY
SELECT* FROM PHIEUTHUE
INSERT INTO PHIEUTHUE VALUES ('PT145','DG001','1/10/2020','20/10/2020',2) --Error
UPDATE PHIEUTHUE
SET NgayTra = '21/10/2020'--Error
WHERE MaPT = 'PT144'

/*2.2. Số sách thuê trong bảng phiếu thuê bằng tổng số lần thuê sách có trong bảng chi tiết
phiếu thuê.*/
GO
CREATE TRIGGER TRG_PHIEUTHUE_SoSachThue_UPD ON PHIEUTHUE
FOR UPDATE
AS
BEGIN
	DECLARE @MAPT CHAR(5),
			@SoSachThue INT,
			@TONGSOCHITIETPT INT

	SELECT @MAPT = MAPT, @SoSachThue = SoSachThue
	FROM INSERTED
	
	SELECT @TONGSOCHITIETPT = COUNT(*)
	FROM CHITIET_PT
	WHERE MaPT = @MAPT

	IF(@TONGSOCHITIETPT <> @SoSachThue)
	BEGIN
		PRINT 'LOI: SO SACH THUE PHAI BANG TONG SO LAN THUE SACH'
		ROLLBACK TRANSACTION
	END
END
--Kiểm tra Trigger
INSERT INTO PHIEUTHUE VALUES('PT100','DG002','1/4/2019','2/4/2019',0)
SELECT* FROM PHIEUTHUE WHERE MaPT = 'PT100'
INSERT INTO CHITIET_PT VALUES('PT100', 'S0009')
INSERT INTO CHITIET_PT VALUES('PT100', 'S0003')
UPDATE PHIEUTHUE
SET SoSachThue = 0 --Error
WHERE MaPT = 'PT100'

GO 
CREATE TRIGGER TRG_CHITIET_PT_INS_DEL ON CHITIET_PT
AFTER INSERT, DELETE
AS
BEGIN
	DECLARE @MaPT CHAR(5), @TongSoSachSeXoa SMALLINT

	IF EXISTS(SELECT* FROM INSERTED) AND NOT EXISTS (SELECT* FROM DELETED)
	BEGIN
		SELECT @MaPT = MaPT
		FROM INSERTED

		UPDATE PHIEUTHUE
		SET SoSachThue = SoSachThue + 1
		WHERE MaPT = @MaPT

		PRINT 'THEM CHI TIET PHIEU THUE THANH CONG'
	END

	IF NOT EXISTS(SELECT* FROM INSERTED) AND EXISTS (SELECT* FROM DELETED)
	BEGIN
		SELECT @MaPT = MaPT, @TongSoSachSeXoa = COUNT(MaSach)
		FROM DELETED
		GROUP BY MaPT 

		UPDATE PHIEUTHUE
		SET SoSachThue = SoSachThue - @TongSoSachSeXoa
		WHERE MaPT = @MaPT

		PRINT 'XOA CHI TIET PHIEU THUE THANH CONG'
	END
END
--Kiểm tra Trigger
INSERT INTO CHITIET_PT VALUES('PT100', 'S0010')
DELETE FROM CHITIET_PT WHERE MaPT = 'PT100'
DELETE FROM CHITIET_PT WHERE MaPT = 'PT100' AND MaSach = 'S0010'

/*3.1 Tìm các độc giả (MaDG,HoTen) đã thuê sách thuộc thể loại “Tin học” trong năm 2007.*/
SELECT DG.MaDG, HoTen, TheLoai
FROM ((SACH S JOIN CHITIET_PT CTPT ON S.MaSach = CTPT.MaSach)
		JOIN PHIEUTHUE PT ON PT.MaPT = CTPT.MaPT)
			JOIN DOCGIA DG ON DG.MaDG = PT.MaDG
WHERE TheLoai = 'Tin hoc'
AND YEAR(NgayThue) = 2007

/*3.2. Tìm các độc giả (MaDG,HoTen) đã thuê nhiều thể loại sách nhất.*/
SELECT TOP 1 WITH TIES DG.MaDG, HoTen, COUNT(DISTINCT TheLoai) SOTHELOAI
FROM ((SACH S JOIN CHITIET_PT CTPT ON S.MaSach = CTPT.MaSach)
		JOIN PHIEUTHUE PT ON PT.MaPT = CTPT.MaPT)
			JOIN DOCGIA DG ON DG.MaDG = PT.MaDG
GROUP BY DG.MaDG, HoTen
ORDER BY SOTHELOAI DESC

/*3.3. Trong mỗi thể loại sách, cho biết tên sách được thuê nhiều nhất.*/ 
SELECT TheLoai, TenSach, COUNT(MaPT) SOLANPH
FROM SACH S1 JOIN CHITIET_PT CTPT ON S1.MaSach = CTPT.MaSach
GROUP BY TheLoai, S1.MaSach, TenSach
HAVING COUNT(MaPT) >= ALL(	SELECT COUNT(MaPT)
							FROM SACH S2 JOIN CHITIET_PT CTPT ON S2.MaSach = CTPT.MaSach
							GROUP BY TheLoai, S2.MaSach, TenSach
							HAVING S1.TheLoai = S2.TheLoai)
