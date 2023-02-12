﻿SELECT* FROM KHACHHANG -- còn câu 13,14,15,18,19
SELECT* FROM CTHD
SELECT* FROM SANPHAM
SELECT* FROM NHANVIEN
SELECT* FROM HOADON

/*I. Data Definition Language*/
/*Câu 2: Thêm vào thuộc tính GHICHU có kiểu dữ liệu varchar(20) cho quan hệ SANPHAM.*/
ALTER TABLE SANPHAM ADD GHICHU varchar(20)

/*Câu 3: Thêm vào thuộc tính LOAIKH có kiểu dữ liệu là tinyint cho quan hệ KHACHHANG.*/
ALTER TABLE KHACHHANG ADD LOAIKH tinyint

/*Câu 4: Sửa kiểu dữ liệu của thuộc tính GHICHU trong quan hệ SANPHAM thành varchar(100).*/
ALTER TABLE SANPHAM ALTER COLUMN GHICHU varchar(100)

/*Câu 5: Xóa thuộc tính GHICHU trong quan hệ SANPHAM.*/
ALTER TABLE SANPHAM DROP COLUMN GHICHU
--ALTER TABLE SANPHAM ADD DVT varchar(20)

/*Câu 6: Làm thế nào để thuộc tính LOAIKH trong quan hệ KHACHHANG có thể lưu các giá trị là: “Vang
lai”, “Thuong xuyen”, “Vip”, ...*/
ALTER TABLE KHACHHANG ALTER COLUMN LOAIKH varchar(50)
ALTER TABLE KHACHHANG ADD CONSTRAINT KHACHHANG_LOAIKH_CK
CHECK(LOAIKH IN ('Vang lai','Thuong xuyen','Vip'))

/*Câu 7: Đơn vị tính của sản phẩm chỉ có thể là (“cay”,”hop”,”cai”,”quyen”,”chuc”)*/
ALTER TABLE SANPHAM ADD CHECK(DVT IN('CAY','HOP','CAI','QUYEN','CHUC'))

/*Câu 8: Giá bán của sản phẩm từ 500 đồng trở lên.*/
ALTER TABLE SANPHAM ADD CHECK(GIA > 500)

/*Câu 9: Mỗi lần mua hàng, khách hàng phải mua ít nhất 1 sản phẩm.*/
ALTER TABLE CTHD ADD CHECK(SL >= 1)

/*Câu 10: Ngày khách hàng đăng ký là khách hàng thành viên phải lớn hơn ngày sinh của người đó.*/
ALTER TABLE KHACHHANG ADD CHECK(NGDK > NGSINH)

/*Câu 11: Ngày mua hàng (NGHD) của một khách hàng thành viên sẽ lớn hơn hoặc bằng ngày khách hàng đó
đăng ký thành viên (NGDK).*/
GO
CREATE TRIGGER HOADON_THEMSUA_MAKH_NGHD ON HOADON
FOR INSERT, UPDATE
AS
BEGIN
    DECLARE @NGDK SMALLDATETIME, @NGHD SMALLDATETIME, @MAKH CHAR(4) /*Biến liên quan đến ràng buộc, đặt là gì cũng đc, cùng kdl đã cho*/
    SELECT @MAKH  = MAKH, @NGHD = NGHD --Gán vào biến tạm
	FROM INSERTED /*Bảng tạm: Cấu trúc y chang bảng đang viết (bảng HOADON)*/
	
	SELECT @NGDK = NGDK
	FROM KHACHHANG
	WHERE MAKH = @MAKH 

    IF(@NGDK > @NGHD)
    BEGIN 
        PRINT 'ERROR: Ngay dang ki thanh vien lon hon ngay mua hang'
        ROLLBACK TRANSACTION /*Hủy thao tác vừa làm - Không cho INSERT, UPDATE data vào trong hệ thống*/
    END
    ELSE
    BEGIN
        PRINT 'Them thanh cong'
    END
END

GO
CREATE TRIGGER KHACHANG_SUA_NGDK ON KHACHHANG
FOR UPDATE
AS
BEGIN
	DECLARE @NGHD SMALLDATETIME, @NGDK SMALLDATETIME, @MAKH CHAR(4), @SOHD INT
	
	SELECT @MAKH = MAKH, @NGDK = NGDK
	FROM INSERTED

	DECLARE cursorDK CURSOR FOR
		SELECT SOHD 
		FROM HOADON 
		WHERE MAKH = @MAKH
	
	OPEN cursorDK
	FETCH NEXT FROM cursorDK 
	INTO @SOHD

	WHILE @@FETCH_STATUS = 0
	BEGIN
		SELECT @NGHD = NGHD
		FROM HOADON
		WHERE SOHD = @SOHD
		IF(@NGHD < @NGDK)
			BEGIN
				PRINT 'ERORR: Loi ngay dang ki!'
				ROLLBACK TRANSACTION
			END
		ELSE
		BEGIN
			FETCH NEXT FROM cursorDK
						INTO @SOHD
		END
	END

	CLOSE cursorDK
	PRINT 'Them thanh cong'
	DEALLOCATE cursorDK
END

/*Kiểm tra dữ liệu*/
SELECT* FROM HOADON WHERE MAKH = 'KH02'
SELECT* FROM KHACHHANG WHERE MAKH = 'KH02'
INSERT INTO HOADON VALUES(1446,'1/1/2001','KH02','NV03',0) --Chỗ này phải bằng 0
DELETE FROM HOADON WHERE SOHD = '1445'

SELECT* FROM HOADON
UPDATE KHACHHANG 
SET NGDK = '22/7/2006'
WHERE MAKH = 'KH01'
INSERT INTO HOADON VALUES(1444,'1/1/2007','KH01','NV03',300000)
DROP TRIGGER HOADON_THEM_SUA
DROP TRIGGER KHACHANG_SUA

/*Câu 12: Ngày bán hàng (NGHD) của một nhân viên phải lớn hơn hoặc bằng ngày nhân viên đó vào làm.*/
GO
CREATE TRIGGER TRG_HOADON_NGHD_MANV_INS_UPD ON HOADON
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @NGVL SMALLDATETIME, @NGHD SMALLDATETIME, @MANV CHAR(4)
	SELECT @MANV = MANV, @NGHD = NGHD
	FROM INSERTED

	SELECT @NGVL = NGVL
	FROM NHANVIEN
	WHERE MANV = @MANV
	IF(@NGVL > @NGHD)

	BEGIN 
        PRINT 'ERROR: Ngay vao lam lon hon ngay mua hang'
        ROLLBACK TRANSACTION
    END
END

GO
CREATE TRIGGER NHANVIEN_SUA_NGVL ON NHANVIEN
FOR UPDATE
AS
BEGIN
	DECLARE @NGHD SMALLDATETIME, @NGVL SMALLDATETIME, @MANV CHAR(4), @SOHD INT
	SELECT @MANV = MANV, @NGVL = NGVL
	FROM INSERTED
	DECLARE cursorDK CURSOR 
	FOR
		SELECT SOHD 
		FROM HOADON 
		WHERE MANV = @MANV
	
	OPEN cursorDK
		FETCH NEXT FROM cursorDK into @SOHD
		WHILE @@FETCH_STATUS = 0
		BEGIN
			SELECT @NGHD = NGHD
			FROM HOADON
			WHERE SOHD = @SOHD
			IF(@NGHD < @NGVL)
				BEGIN
					PRINT 'ERORR: Loi ngay dang ki!'
					ROLLBACK TRANSACTION
				END
			ELSE
			BEGIN
				FETCH NEXT FROM cursorDK
						INTO @SOHD
			END
		END
	CLOSE cursorDK
	DEALLOCATE cursorDK
END

--Kiểm tra dữ liệu
SET DATEFORMAT DMY
INSERT INTO HOADON VALUES(1444,'1/1/2007','KH01','NV03',300000)
DELETE FROM HOADON WHERE SOHD = '1444'
UPDATE NHANVIEN
SET NGVL = '22/7/2001'
WHERE MANV = 'NV01'

/*Câu 13: Mỗi một hóa đơn phải có ít nhất một chi tiết hóa đơn.*/
GO
CREATE TRIGGER TRG_CTHD_SOHD_DEL ON CTHD
FOR DELETE
AS
BEGIN
	DECLARE @SoLuongCTHDSeXoa INT, 
			@SoLuongCTHDHienTai INT,
			@SOHD INT
		
	SELECT @SOHD = SOHD, @SoLuongCTHDSeXoa = COUNT(*) --Hạn chế: Nếu DELETE có OR
	FROM DELETED
	GROUP BY SOHD

	SELECT @SoLuongCTHDHienTai = COUNT(*)
	FROM CTHD
	WHERE SOHD = @SOHD

	IF(@SoLuongCTHDHienTai - @SoLuongCTHDSeXoa < 1)
	BEGIN
		PRINT 'trg_CTHD_XOASUA_SOHD: Moi hoa don phai co it nhat mot CTHD'
		ROLLBACK TRANSACTION
	END
END
--Kiểm tra Trigger
SELECT* FROM HOADON
SELECT* FROM CTHD
SELECT* FROM CTHD WHERE SOHD = '1003'
SELECT* FROM HOADON WHERE SOHD = '1003'
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1003,'BB03',10)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1003,'BB03',111)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1004,'BB03',111)
DELETE FROM CTHD WHERE SOHD = '1003'
DELETE FROM CTHD WHERE SL = 111
DROP TRIGGER trg_CTHD_XOASUA_SOHD

GO
CREATE TRIGGER TRG_HOADON_INS ON HOADON
FOR INSERT --Lúc tạo hóa đơn phải tự động thêm vào 1 chi tiết hóa đơn
AS
BEGIN
	DECLARE @SOHD INT

	SELECT @SOHD = SOHD
	FROM INSERTED
END

/*Câu 14: Trị giá của một hóa đơn là tổng thành tiền (số lượng*đơn giá) của các chi tiết thuộc hóa đơn đó.*/
GO 
CREATE TRIGGER TRG_HOADON_TRIGIA_UPD ON HOADON
FOR UPDATE
AS
BEGIN
	DECLARE @TRIGIA MONEY,
			@TONGTRIGIA INT,
			@SOHD INT

	SELECT @TRIGIA = TRIGIA, @SOHD = SOHD
	FROM INSERTED

	SELECT @TONGTRIGIA = SUM(SL * GIA)
	FROM SANPHAM SP JOIN CTHD ON SP.MASP = CTHD.MASP
	WHERE SOHD = @SOHD

	IF(@TONGTRIGIA <> @TRIGIA)
	BEGIN
		PRINT('TRG_HOADON_TRIGIA_UPD: TRI GIA HD LA TONG THANH TIEN CUA CAC CHI TIET THUOC HOA HON DO')
		ROLLBACK TRANSACTION
	END
END
--Kiểm tra Trigger
SELECT* FROM HOADON WHERE SOHD = 1444
SELECT* FROM CTHD WHERE SOHD = 1444
INSERT INTO CTHD VALUES(1444,'BB01',1)
INSERT INTO CTHD VALUES(1444,'BB02',1)
UPDATE HOADON
SET TRIGIA = 13000
WHERE SOHD = 1444
DROP TRIGGER TRG_HOADON_TRIGIA_UPD

GO 
CREATE TRIGGER TRG_CTHD_SL_MASP_INS_DEL_UPD ON CTHD
FOR INSERT, DELETE, UPDATE
AS
BEGIN
	DECLARE @SL_MOI INT, 
			@SL_CU INT,
			@SOHD INT,
			@MASP CHAR(4),
			@DONGIA MONEY
	
	SELECT @SOHD = SOHD, @MASP = MASP, @SL_MOI = SL
	FROM inserted

	SELECT @SOHD = SOHD, @MASP = MASP, @SL_CU = SL
	FROM deleted

	SELECT @DONGIA = GIA
	FROM SANPHAM
	WHERE MASP = @MASP

	IF EXISTS (SELECT* FROM inserted) AND EXISTS (SELECT* FROM deleted)
	BEGIN
		UPDATE HOADON
		SET TRIGIA = TRIGIA - @DONGIA*@SL_CU + @DONGIA*@SL_MOI
		WHERE SOHD = @SOHD
		PRINT('UPDATE CTHD THANH CONG')
	END

	IF EXISTS (SELECT* FROM inserted) AND NOT EXISTS (SELECT* FROM deleted)
	BEGIN
		UPDATE HOADON
		SET TRIGIA = TRIGIA + @DONGIA*@SL_MOI
		WHERE SOHD = @SOHD
		PRINT('THEM CTHD THANH CONG')
	END

	IF NOT EXISTS (SELECT* FROM inserted) AND EXISTS (SELECT* FROM deleted)
	BEGIN
		UPDATE HOADON
		SET TRIGIA = TRIGIA - @DONGIA*@SL_CU
		WHERE SOHD = @SOHD
		PRINT('XOA CTHD THANH CONG')
	END
END
--Kiểm tra Trigger
SELECT* FROM HOADON WHERE SOHD = 1444
SELECT* FROM CTHD WHERE SOHD = 1444
SELECT* FROM SANPHAM
INSERT INTO CTHD VALUES(1444,'BC01',1)
DELETE FROM CTHD WHERE SOHD = 1444 AND MASP = 'BC01'
UPDATE CTHD
SET SL = 3
WHERE SOHD = 1444 AND MASP = 'BB01'

GO --Chưa chạy đc
CREATE TRIGGER TRG_SANPHAM_GIA_UPD ON SANPHAM
FOR UPDATE
AS
BEGIN
	DECLARE @MASP CHAR(4),
			@GIAMOI MONEY,
			@GIACU MONEY,
			@SOHD INT,
			@SL INT

	SELECT @MASP = MASP, @GIAMOI = GIA
	FROM INSERTED

	SELECT @GIACU = GIA
	FROM DELETED

	DECLARE cur_CTHD CURSOR
	FOR
		SELECT SOHD, SL
		FROM CTHD
		WHERE MASP = @MASP

	OPEN cur_CTHD
	FETCH NEXT FROM cur_CTHD INTO @SOHD, @SL

	WHILE @@FETCH_STATUS = 0
	BEGIN
		UPDATE HOADON
		SET TRIGIA = TRIGIA - @GIACU * @SL + @GIAMOI * @SL
		WHERE SOHD = @SOHD
		
		FETCH NEXT FROM cur_CTHD INTO @SOHD, @SL
	END
END
--Kiểm tra Trigger
SELECT* FROM HOADON WHERE SOHD = 1444
SELECT* FROM CTHD WHERE SOHD = 1444
SELECT* FROM SANPHAM
INSERT INTO SANPHAM VALUES('BB04','BUT BI','HOP','VIETNAM',50000)
INSERT INTO CTHD VALUES(1444,'BB04',1)
DELETE FROM CTHD 
WHERE SOHD = 1444 AND MASP = 'BB04'
UPDATE SANPHAM
SET GIA = 40000
WHERE MASP = 'BB04'
DROP TRIGGER TRG_SANPHAM_GIA_UPD

/*Trigger cập nhật lại trị giá hóa đơn khi có
một chi tiết hóa đơn mới được thêm vào.
GO
CREATE TRIGGER TRG_INS_CTHD ON CTHD
FOR INSERT
AS
BEGIN
	DECLARE @SOHD INT, @MASP CHAR(4), @SOLUONG INT, @TRIGIA MONEY
	--Lấy thông tin của CTHD vừa mới thêm vào
	SELECT @SOHD = SOHD, @MASP = MASP, @SOLUONG = SL
	FROM INSERTED
	-- Tính trị giá của sản phẩm mới thêm vào HOADON
	SET @TRIGIA = @SOLUONG * (SELECT GIA FROM SANPHAM WHERE MASP = @MASP)
	-- Khai báo một CURSOR duyệt qua tất cả các CTHD đã có sẵn trong HOADON
	DECLARE cur_CTHD CURSOR FOR
		SELECT MASP, SL
		FROM CTHD
		WHERE SOHD = @SOHD
	
	OPEN cur_CTHD
	FETCH NEXT FROM cur_CTHD
	INTO @MASP, @SOLUONG

	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- Cộng dồn trị giá của từng sản phẩm vào biến TRIGIA
		SET @TRIGIA = @TRIGIA + @SOLUONG * (SELECT GIA FROM SANPHAM WHERE MASP = @MASP)
		FETCH NEXT FROM cur_CTHD
		INTO @MASP, @SOLUONG
	END

	CLOSE cur_CTHD
	DEALLOCATE cur_CTHD
	--Tiến hành cập nhập lại giá trị HOADON
	UPDATE HOADON SET TRIGIA = @TRIGIA WHERE SOHD = @SOHD
END*/


/*Câu 15: Doanh số của một khách hàng là tổng trị giá các hóa đơn mà khách hàng thành viên đó đã mua.*/
GO
CREATE TRIGGER TRG_KHACHHANG_DOANHSO_UPD
ON KHACHHANG
FOR UPDATE
AS
BEGIN
	DECLARE @MAKH  CHAR(4), @DOANHSO MONEY, @TONGTRIGIA MONEY, @TRIGIA MONEY

	SELECT @MAKH = MAKH, @DOANHSO = DOANHSO
	FROM  INSERTED
	
	SET @TONGTRIGIA = 0

	DECLARE cur_HOADON CURSOR FOR
		SELECT MAKH, TRIGIA
		FROM HOADON
		WHERE MAKH = @MAKH
	
	OPEN cur_HOADON
	FETCH NEXT FROM cur_HOADON
	INTO @MAKH, @TRIGIA

	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @TONGTRIGIA = @TONGTRIGIA +  @TRIGIA
		FETCH NEXT FROM cur_HOADON
		INTO @MAKH, @TRIGIA
	END

	CLOSE cur_HOADON
	DEALLOCATE cur_HOADON

	IF @DOANHSO <> @TONGTRIGIA
	BEGIN
		PRINT 'ERROR: TRG_KHACHHANG_DOANHSO_UPD'
		ROLLBACK TRAN
	END
END
--Kiểm tra Trigger		
SELECT * FROM KHACHHANG
SELECT * FROM HOADON
INSERT INTO KHACHHANG VALUES('KH11','NGUYEN TEST', '731TRAN HUNG DAO,Q7,THHCM','08823451','1960-10-22 00:00:00',0, '2006-07-22 00:00:00', null)
INSERT INTO HOADON VALUES('1444','2006-07-27 00:00:00','KH11','NV01','100')
INSERT INTO HOADON VALUES('1445','2006-08-27 00:00:00','KH11','NV01','200')
INSERT INTO HOADON VALUES('1446','2006-09-27 00:00:00','KH11','NV01','100')
UPDATE KHACHHANG
SET DOANHSO = 400
WHERE MAKH = 'KH11'
DELETE FROM KHACHHANG WHERE MAKH = 'KH11'

GO
CREATE TRIGGER TRG_HOADON_TRIGIA_INS ON HOADON
AFTER INSERT 
AS
	DECLARE @MAKH char(4), 
			@TRIGIA money
	BEGIN
		 SELECT @MAKH = MAKH , @TRIGIA = TRIGIA
		 FROM inserted

		 UPDATE KHACHHANG
		 SET DOANHSO = DOANHSO + @TRIGIA
		 WHERE MAKH = @MAKH
	END

--Kiểm tra Trigger 
INSERT INTO KHACHHANG VALUES 
('KH50' ,'Nguyen Van A', '731TRAN HUNG DAO,Q5,THHCM', '08823451', '1960-10-22 00:00:00', 0, '2006-07-22 00:00:00', NULL)
INSERT INTO HOADON (SOHD,MAKH,TRIGIA) VALUES (3000,'KH50' , 2500)
SELECT *FROM KHACHHANG WHERE MAKH='KH50'
INSERT INTO HOADON (SOHD,MAKH,TRIGIA) VALUES (3001,'KH50' , 4000)
DELETE FROM HOADON WHERE MAKH = 'KH50'
DELETE FROM KHACHHANG WHERE MAKH = 'KH50'
DROP TRIGGER TRG_HOADON_DOANHSO_INS

GO
CREATE TRIGGER TRG_HOADON_TRIGIA_DEL ON HOADON
AFTER DELETE
AS
BEGIN
	DECLARE @MAKH char(4), 
			@TRIGIA money
	
	SELECT @MAKH = MAKH, @TRIGIA = TRIGIA
	FROM DELETED

	UPDATE KHACHHANG
	SET DOANHSO = DOANHSO - @TRIGIA
	WHERE MAKH = @MAKH
END
--Kiểm tra Trigger
INSERT INTO HOADON (SOHD,MAKH,TRIGIA) VALUES (4001,'KH51' , 3000)
INSERT INTO HOADON (SOHD,MAKH,TRIGIA) VALUES (4002,'KH51' , 1000)
SELECT* FROM KHACHHANG WHERE MAKH = 'KH51'
DELETE FROM HOADON WHERE SOHD = 4002

GO -- Chưa update đc MAKH
CREATE TRIGGER TRG_HOADON_TRIGIA_UPD ON HOADON
FOR UPDATE
AS
BEGIN
	DECLARE @MAKH CHAR(4),
			@TRIGIA_MOI MONEY,
			@TRIGIA_CU MONEY

	SELECT @MAKH = MAKH, @TRIGIA_CU = TRIGIA
	FROM DELETED

	SELECT @MAKH = MAKH, @TRIGIA_MOI = TRIGIA
	FROM INSERTED

	UPDATE KHACHHANG
	SET DOANHSO = DOANHSO - @TRIGIA_CU + @TRIGIA_MOI
	WHERE MAKH = @MAKH
END
--Kiểm tra Trigger
UPDATE HOADON
SET TRIGIA = TRIGIA - 100
WHERE SOHD = '4002'
UPDATE HOADON
SET MAKH = 'KH51'
WHERE SOHD = '4002'
SELECT* FROM KHACHHANG WHERE MAKH = 'KH51'
SELECT* FROM KHACHHANG WHERE MAKH = 'KH50'
SELECT* FROM HOADON WHERE MAKH = 'KH50'

/*Cách 2: Làm gộp 3 trigger*/ --Chưa thể update MAKH
GO
CREATE TRIGGER TRG_HOADON_TRIGIA_INS_DEL_UPD ON HOADON
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
	DECLARE @MAKH CHAR(4),
			@TRIGIA_MOI MONEY,
			@TRIGIA_CU MONEY

	SELECT @MAKH = MAKH, @TRIGIA_CU = TRIGIA
	FROM DELETED

	SELECT @MAKH = MAKH, @TRIGIA_MOI = TRIGIA
	FROM INSERTED

	IF EXISTS(SELECT* FROM INSERTED) AND EXISTS(SELECT* FROM DELETED)
	BEGIN 
		UPDATE KHACHHANG
		SET DOANHSO = DOANHSO - @TRIGIA_CU + @TRIGIA_MOI
		WHERE MAKH = @MAKH
		PRINT('UPDATE HOA DON THANH CONG')
	END

	IF EXISTS(SELECT* FROM INSERTED) AND NOT EXISTS(SELECT* FROM DELETED)
	BEGIN 
		UPDATE KHACHHANG
		SET DOANHSO = DOANHSO + @TRIGIA_MOI
		WHERE MAKH = @MAKH
		PRINT('THEM HOA DON THANH CONG')
	END

	IF NOT EXISTS(SELECT* FROM INSERTED) AND EXISTS(SELECT* FROM DELETED)
	BEGIN 
		UPDATE KHACHHANG
		SET DOANHSO = DOANHSO - @TRIGIA_CU
		WHERE MAKH = @MAKH
		PRINT('XOA HOA DON THANH CONG')
	END
END
--Kiểm tra Trigger
DROP TRIGGER TRG_HOADON_TRIGIA_INS
DROP TRIGGER TRG_HOADON_TRIGIA_DEL
DROP TRIGGER TRG_HOADON_TRIGIA_UPD
INSERT INTO KHACHHANG VALUES 
('KH52' ,'Nguyen Van B', '731TRAN HUNG DAO,Q5,THHCM', '08823451', '1960-10-22 00:00:00', 0, '2006-07-22 00:00:00', NULL)
INSERT INTO HOADON (SOHD,MAKH,TRIGIA) VALUES (5001,'KH52' , 2000)
SELECT* FROM KHACHHANG WHERE MAKH = 'KH52'
DELETE FROM HOADON WHERE SOHD = 5001
UPDATE HOADON
SET TRIGIA = TRIGIA + 100
WHERE SOHD = 5000

/*II. Data Manipulation Language*/
/*Câu 2: Tạo quan hệ SANPHAM1 chứa toàn bộ dữ liệu của quan hệ SANPHAM. Tạo quan hệ
KHACHHANG1 chứa toàn bộ dữ liệu của quan hệ KHACHHANG.*/
SELECT* INTO SANPHAM1 FROM SANPHAM
SELECT* INTO KHACHHANG1 FROM KHACHHANG

/*Câu 3: Cập nhật giá tăng 5% đối với những sản phẩm do “Thai Lan” sản xuất (cho quan hệ SANPHAM1)*/
UPDATE SANPHAM1
SET GIA = GIA*1.05
WHERE NUOCSX = 'Thai Lan'

/*Câu 4: Cập nhật giá giảm 5% đối với những sản phẩm do “Trung Quoc” sản xuất có giá từ 10.000 trở xuống
(cho quan hệ SANPHAM1).*/
UPDATE SANPHAM1
SET GIA = 0.95*GIA
WHERE NUOCSX = 'Trung Quoc'

/*Câu 5: Cập nhật giá trị LOAIKH là “Vip” đối với những khách hàng đăng ký thành viên trước ngày
1/1/2007 có doanh số từ 10.000.000 trở lên hoặc khách hàng đăng ký thành viên từ 1/1/2007 trở về
sau có doanh số từ 2.000.000 trở lên (cho quan hệ KHACHHANG1).*/
UPDATE KHACHHANG1
SET LOAIKH = 'Vip'
WHERE (NGDK < '1/1/2007' AND DOANHSO > 10000000) 
OR (NGDK > '1/1/2007' AND DOANHSO > 2000000)

/*II. Data Access Language*/
/*Câu 1: In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” sản xuất.*/
SELECT MASP, TENSP
FROM SANPHAM 
WHERE NUOCSX = 'TRUNGQUOC'

/*Câu 2: In ra danh sách các sản phẩm (MASP, TENSP) có đơn vị tính là “cay”, ”quyen”.*/
SELECT MASP, TENSP
FROM SANPHAM
WHERE (DVT = 'CAY' OR DVT = 'QUYEN')

/*Câu 3: In ra danh sách các sản phẩm (MASP,TENSP) có mã sản phẩm bắt đầu là “B” và kết thúc là “01”.*/
SELECT MASP,TENSP FROM SANPHAM
WHERE MASP LIKE 'B%01'

/*Câu 4: In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quốc” sản xuất có giá từ 30.000 đến
40.000.*/
SELECT  MASP,TENSP FROM SANPHAM
WHERE NUOCSX = 'TRUNGQUOC' 
AND (GIA BETWEEN 30000 AND 40000)

/*Câu 5: In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” hoặc “Thai Lan” sản xuất có giá từ
30.000 đến 40.000.*/
SELECT MASP, TENSP FROM SANPHAM
WHERE (NUOCSX = 'TRUNG QUOC' OR NUOCSX = 'THAILAN') 
AND (GIA BETWEEN 30000 AND 40000)

/*Câu 6: In ra các số hóa đơn, trị giá hóa đơn bán ra trong ngày 1/1/2007 và ngày 2/1/2007.*/
SELECT SOHD, TRIGIA 
FROM HOADON 
WHERE (NGHD = '1/1/2007' OR NGHD = '2/1/2007')

/*Câu 7: In ra các số hóa đơn, trị giá hóa đơn trong tháng 1/2007, sắp xếp theo ngày (tăng dần) và trị giá của
hóa đơn (giảm dần).*/
SELECT SOHD, TRIGIA FROM HOADON 
WHERE (MONTH(NGHD)=1 AND YEAR(NGHD) = 2007)
ORDER BY NGHD ASC, TRIGIA DESC

/*Câu 8: In ra danh sách các khách hàng (MAKH, HOTEN) đã mua hàng trong ngày 1/1/2007.*/
SELECT KHACHHANG.MAKH, HOTEN 
FROM HOADON, KHACHHANG 
WHERE KHACHHANG.MAKH = HOADON.MAKH 
AND NGHD = '1/1/2007'

/*Câu 9: In ra số hóa đơn, trị giá các hóa đơn do nhân viên có tên “Nguyen Van B” lập trong ngày
28/10/2006.*/
SELECT HOADON.SOHD, TRIGIA 
FROM HOADON, NHANVIEN
WHERE NGHD = '28/10/2006' 
AND NHANVIEN.HOTEN = 'Nguyen Van B' 
AND HOADON.MANV = NHANVIEN.MANV

/*Câu 10: In ra danh sách các sản phẩm (MASP,TENSP) được khách hàng có tên “Nguyen Van A” mua trong
tháng 10/2006.*/
SELECT SANPHAM.MASP, TENSP
FROM HOADON, KHACHHANG, SANPHAM, CTHD
WHERE (MONTH(NGHD) = 10 AND YEAR(NGHD) = 2006) 
AND KHACHHANG.HOTEN = 'Nguyen Van A' 
AND HOADON.MAKH = KHACHHANG.MAKH 
AND CTHD.MASP = SANPHAM.MASP 
AND HOADON.SOHD = CTHD.SOHD

/*Câu 11: Tìm các số hóa đơn đã mua sản phẩm có mã số “BB01” hoặc “BB02”.*/
SELECT DISTINCt CTHD.SOHD
FROM CTHD, SANPHAM, HOADON
WHERE (SANPHAM.MASP = 'BB01'OR SANPHAM.MASP = 'BB02')
AND SANPHAM.MASP = CTHD.MASP
AND HOADON.SOHD = CTHD.SOHD

/*Câu 12: Tìm các số hóa đơn đã mua sản phẩm có mã số “BB01” hoặc “BB02”, mỗi sản phẩm mua với số
lượng từ 10 đến 20.*/
SELECT DISTINCT SOHD
FROM CTHD
WHERE (CTHD.MASP='BB02' OR CTHD.MASP='BB01') 
AND (SL BETWEEN 10 AND 20)

/*Câu 13: Tìm các số hóa đơn mua cùng lúc 2 sản phẩm có mã số “BB01” và “BB02”, mỗi sản phẩm mua với
số lượng từ 10 đến 20.*/
--Cách 1:
SELECT DISTINCT SOHD
FROM CTHD
WHERE MASP IN ('BB01','BB02')
AND SL BETWEEN 10 AND 20

--Cách 2: Dùng mệnh đề INTERSECT
SELECT SOHD
FROM CTHD
WHERE MASP = 'BB01' AND SL BETWEEN 10 AND 20
INTERSECT
SELECT SOHD
FROM CTHD
WHERE MASP = 'BB02' AND SL BETWEEN 10 AND 20

/*Câu 14: In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” sản xuất hoặc các sản phẩm được
bán ra trong ngày 1/1/2007.*/
--Cách 1
SELECT DISTINCT SANPHAM.MASP, TENSP
FROM SANPHAM, CTHD, HOADON
WHERE (SANPHAM.MASP = CTHD.MASP
AND HOADON.SOHD = CTHD.SOHD 
AND NGHD = '1/1/2007')
OR NUOCSX = 'TRUNG QUOC' 

--Cách 2
SELECT DISTINCT SANPHAM.MASP, TENSP
FROM (SANPHAM INNER JOIN CTHD ON SANPHAM.MASP = CTHD.MASP)
			INNER JOIN HOADON ON HOADON.SOHD = CTHD.SOHD
WHERE NGHD='1/1/2007'
UNION
SELECT MASP, TENSP
FROM SANPHAM
WHERE NUOCSX = 'TRUNG QUOC'

/*Câu 15: In ra danh sách các sản phẩm (MASP,TENSP) không bán được.*/
--Cách 1
SELECT MASP, TENSP
FROM SANPHAM
EXCEPT
SELECT CTHD.MASP, TENSP
FROM CTHD, SANPHAM
WHERE CTHD.MASP = SANPHAM.MASP

--Cách 2
SELECT MASP, TENSP
FROM SANPHAM SP
WHERE SP.MASP NOT IN( SELECT DISTINCT MASP
						FROM CTHD)

/*Câu 16: In ra danh sách các sản phẩm (MASP,TENSP) không bán được trong năm 2006.*/
--Cách 1
SELECT MASP, TENSP
FROM SANPHAM
EXCEPT
SELECT CTHD.MASP, TENSP
FROM SANPHAM, CTHD, HOADON
WHERE CTHD.MASP = SANPHAM.MASP
AND CTHD.SOHD = HOADON.SOHD
AND YEAR(NGHD) = 2006

--Cách 2
SELECT MASP, TENSP
FROM SANPHAM
WHERE MASP NOT IN ( SELECT DISTINCT MASP 
					FROM CTHD, HOADON  
					WHERE CTHD.SOHD = HOADON.SOHD AND YEAR(NGHD) = 2006
				  )	

/*Câu 17: In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” sản xuất không bán được trong
năm 2006.*/
--Cách 1
SELECT MASP, TENSP
FROM SANPHAM
WHERE NUOCSX = 'TRUNGQUOC'
EXCEPT
SELECT CTHD.MASP, TENSP
FROM SANPHAM, CTHD, HOADON
WHERE YEAR(NGHD) = 2006
AND NUOCSX = 'TRUNGQUOC'
AND CTHD.MASP = SANPHAM.MASP
AND CTHD.SOHD = HOADON.SOHD

--Cách 2
SELECT MASP, TENSP
FROM SANPHAM
WHERE NUOCSX = 'TRUNGQUOC' AND MASP  NOT IN(
												SELECT CTHD.MASP
												FROM CTHD, HOADON
												WHERE YEAR(NGHD) = 2006
												AND CTHD.SOHD = HOADON.SOHD
											)

/*Câu 18: Tìm số hóa đơn đã mua tất cả các sản phẩm do Singapore sản xuất.*/ 
SELECT SOHD
FROM HOADON HD
WHERE NOT EXISTS(	SELECT*
					FROM SANPHAM SP
					WHERE NUOCSX = 'SINGAPORE'
					AND NOT EXISTS(		SELECT*
										FROM CTHD
										WHERE CTHD.MASP = SP.MASP
										AND CTHD.SOHD = HD.SOHD))

/*Câu 20: Có bao nhiêu hóa đơn không phải của khách hàng đăng ký thành viên mua?*/
SELECT COUNT(*) AS NOTTV
FROM HOADON
WHERE MAKH IS NULL

SELECT COUNT(SOHD) [NOTTV]
FROM HOADON
WHERE MAKH IS NULL

/*Câu 21: Có bao nhiêu sản phẩm khác nhau được bán ra trong năm 2006.*/
SELECT COUNT(DISTINCT MASP) SOSPBANRA
FROM HOADON HD JOIN CTHD ON HD.SOHD = CTHD.SOHD
WHERE YEAR(NGHD) = 2006

/*Câu 22: Cho biết trị giá hóa đơn cao nhất, thấp nhất là bao nhiêu ?*/
SELECT MAX(TRIGIA) AS MAX, MIN(TRIGIA) AS MIN
FROM HOADON

/*Câu 23: Trị giá trung bình của tất cả các hóa đơn được bán ra trong năm 2006 là bao nhiêu?*/
SELECT AVG(TRIGIA) GiaTriTB
FROM HOADON
WHERE YEAR(NGHD) = 2006

/*Câu 24: Tính doanh thu bán hàng trong năm 2006.*/
SELECT SUM(TRIGIA) DoanhThu
FROM HOADON
WHERE YEAR(NGHD) = 2006

/*Câu 25: Tìm số hóa đơn có trị giá cao nhất trong năm 2006.*/
--Cách 1
SELECT TOP 1 WITH TIES SOHD, TRIGIA
FROM HOADON
WHERE YEAR(NGHD) = 2006
ORDER BY TRIGIA DESC

--Cách 2
SELECT SOHD, TRIGIA
FROM HOADON
WHERE YEAR(NGHD) = 2006
AND TRIGIA = (SELECT MAX(TRIGIA) FROM HOADON YEAR(NGHD) = 2006)

/*Câu 26: Tìm họ tên khách hàng đã mua hóa đơn có trị giá cao nhất trong năm 2006.*/
--Cách 1
SELECT TOP 1 WITH TIES HOTEN, TRIGIA
FROM HOADON JOIN KHACHHANG ON HOADON.MAKH = KHACHHANG.MAKH
WHERE YEAR(NGHD) = 2006
ORDER BY TRIGIA DESC

--Cách 2
SELECT HOTEN, TRIGIA
FROM HOADON JOIN KHACHHANG ON HOADON.MAKH = KHACHHANG.MAKH
WHERE YEAR(NGHD) = 2006
AND TRIGIA = (SELECT MAX(TRIGIA) FROM HOADON WHERE YEAR(NGHD) = 2006)

/*Câu 27: In ra danh sách 3 khách hàng đầu tiên (MAKH, HOTEN) sắp xếp theo doanh số giảm dần.*/
SELECT TOP 3 MAKH, HOTEN
FROM KHACHHANG 
ORDER BY DOANHSO DESC

/*Câu 28: In ra danh sách các sản phẩm (MASP, TENSP) có giá bán bằng 1 trong 3 mức giá cao nhất.*/
SELECT MASP, TENSP
FROM SANPHAM 
WHERE GIA IN(	SELECT DISTINCT TOP 3 GIA
				FROM SANPHAM
				ORDER BY GIA DESC)

/*Câu 29: In ra danh sách các sản phẩm (MASP, TENSP) do “Thai Lan” sản xuất có giá bằng 1 trong 3 mức
giá cao nhất (của tất cả các sản phẩm).*/
SELECT MASP, TENSP
FROM SANPHAM 
WHERE NUOCSX = 'THAILAN'
AND GIA IN(		SELECT DISTINCT TOP 3 GIA
				FROM SANPHAM
				ORDER BY GIA DESC)

/*Câu 30: In ra danh sách các sản phẩm (MASP, TENSP) do “Trung Quoc” sản xuất có giá bằng 1 trong 3 mức
giá cao nhất (của sản phẩm do “Trung Quoc” sản xuất).*/
SELECT MASP, TENSP
FROM SANPHAM 
WHERE NUOCSX = 'TRUNGQUOC'
AND GIA IN(		SELECT DISTINCT TOP 3 GIA
				FROM SANPHAM
				WHERE NUOCSX = 'TRUNGQUOC'
				ORDER BY GIA DESC)

/*Câu 31: *In ra danh sách khách hàng nằm trong 3 hạng cao nhất (xếp hạng theo doanh số).*/
SELECT TOP 3 *
FROM KHACHHANG
ORDER BY DOANHSO DESC

/*Câu 32: Tính tổng số sản phẩm do “Trung Quoc” sản xuất.*/
SELECT COUNT(MASP) [TongSPTrungQuoc]
FROM SANPHAM
WHERE NUOCSX = 'TRUNGQUOC'

/*Câu 33: Tính tổng số sản phẩm của từng nước sản xuất.*/
SELECT NUOCSX ,COUNT(MASP) [SoLuong]
FROM SANPHAM
GROUP BY NUOCSX

/*Câu 34: Với từng nước sản xuất, tìm giá bán cao nhất, thấp nhất, trung bình của các sản phẩm.*/
SELECT NUOCSX, MAX(GIA) GiaBanCaoNhat, MIN(GIA) GiaBanThapNhat, AVG(GIA) GiaBanTB
FROM SANPHAM
GROUP BY NUOCSX

/*Câu 35: Tính doanh thu bán hàng mỗi ngày.*/
SELECT NGHD, SUM(TRIGIA) AS DoanhThu
FROM HOADON
GROUP BY NGHD

/*Câu 36: Tính tổng số lượng của từng sản phẩm bán ra trong tháng 10/2006.*/
SELECT MASP, SUM(SL) TongSanPhamBanRa
FROM CTHD INNER JOIN HOADON ON HOADON.SOHD = CTHD.SOHD
WHERE (MONTH(NGHD)=10 AND YEAR(NGHD)=2006)
GROUP BY MASP

/*Câu 37: Tính doanh thu bán hàng của từng tháng trong năm 2006.*/
SELECT MONTH(NGHD) Tháng, SUM(TRIGIA) DoanhThu
FROM HOADON
WHERE YEAR(NGHD) = 2006
GROUP BY MONTH(NGHD)

/*Câu 38: Tìm hóa đơn có mua ít nhất 4 sản phẩm khác nhau.*/
SELECT SOHD, COUNT(DISTINCT MASP) SoLuongSanPhamKhacNhau
FROM CTHD
GROUP BY SOHD
HAVING COUNT(DISTINCT MASP) >= 4

/*Câu 39: Tìm hóa đơn có mua 3 sản phẩm do “Viet Nam” sản xuất (3 sản phẩm khác nhau).*/
SELECT SOHD, COUNT(DISTINCT SP.MASP)
FROM CTHD JOIN SANPHAM SP ON SP.MASP = CTHD.MASP
WHERE NUOCSX = 'VIETNAM'
GROUP BY SOHD
HAVING COUNT(DISTINCT SP.MASP) = 3

/*Câu 40: Tìm khách hàng (MAKH, HOTEN) có số lần mua hàng nhiều nhất.*/
--Cách 1: Dùng ORDER BY
SELECT TOP 1 WITH TIES KH.MAKH, HOTEN, COUNT(*) SOLANMUAHANG
FROM HOADON HD JOIN KHACHHANG KH ON HD.MAKH = KH.MAKH
GROUP BY KH.MAKH, HOTEN
ORDER BY COUNT(*) DESC

--Cách 2: Dùng HAVING
SELECT KH.MAKH, HOTEN, COUNT(SOHD) SOLANMUAHANG
FROM HOADON HD JOIN KHACHHANG KH ON HD.MAKH = KH.MAKH
GROUP BY KH.MAKH, HOTEN
HAVING COUNT(SOHD) >= ALL(	SELECT  DISTINCT COUNT(SOHD) AS HOADONKH
							FROM HOADON HD JOIN KHACHHANG KH ON HD.MAKH = KH.MAKH
							GROUP BY HOTEN)

/*Câu 41: Tháng mấy trong năm 2006, doanh số bán hàng cao nhất ?*/
--Cách 1: Dùng ORDER BY
SELECT TOP 1 WITH TIES MONTH(NGHD) AS THANG, SUM(TRIGIA) AS DOANHSO
FROM HOADON
WHERE YEAR(NGHD) = 2006
GROUP BY MONTH(NGHD)
ORDER BY SUM(TRIGIA) DESC

--Cách 2: Dùng HAVING
SELECT MONTH(NGHD) AS THANG, SUM(TRIGIA) AS DOANHSO
FROM HOADON
WHERE YEAR(NGHD) = 2006
GROUP BY MONTH(NGHD)
HAVING SUM(TRIGIA) >= ALL (	SELECT SUM(TRIGIA)
							FROM HOADON
							WHERE YEAR(NGHD) = 2006
							GROUP BY MONTH(NGHD))

/*Câu 42: Tìm sản phẩm (MASP, TENSP) có tổng số lượng bán ra thấp nhất trong năm 2006.*/
--Cách 1
SELECT TOP 1 WITH TIES SP.MASP, TENSP, SUM(SL) AS TONGSOLUONG
FROM (SANPHAM SP JOIN CTHD ON SP.MASP = CTHD.MASP)
		JOIN HOADON HD ON HD.SOHD = CTHD.SOHD
WHERE YEAR(NGHD) = 2006
GROUP BY SP.MASP, TENSP 
ORDER BY SUM(SL)

--Cách 2
SELECT MASP, TENSP
FROM SANPHAM
WHERE MASP = (	SELECT TOP 1 MASP
				FROM CTHD JOIN HOADON HD ON HD.SOHD = CTHD.SOHD
				WHERE YEAR(NGHD) = 2006
				GROUP BY MASP
				ORDER BY SUM(SL))

/*Câu 43: *Mỗi nước sản xuất, tìm sản phẩm (MASP,TENSP) có giá bán cao nhất.*/ 
--Cách 1
SELECT NUOCSX, MASP, TENSP
FROM SANPHAM SP1
WHERE GIA IN (	SELECT MAX(GIA)
				FROM SANPHAM SP2
				WHERE SP1.NUOCSX = SP2.NUOCSX )
GROUP BY NUOCSX, MASP, TENSP

--Cách 2
SELECT NUOCSX, MASP, TENSP
FROM SANPHAM SP1
GROUP BY NUOCSX, MASP, TENSP
HAVING MAX(GIA) >=ALL(	SELECT MAX(GIA)
						FROM SANPHAM SP2
						GROUP BY NUOCSX, MASP
						HAVING SP1.NUOCSX = SP2.NUOCSX)

/*Câu 44: Tìm nước sản xuất sản xuất ít nhất 3 sản phẩm có giá bán khác nhau.*/
SELECT NUOCSX, COUNT(DISTINCT GIA) SOGIAKHACNHAU
FROM SANPHAM
GROUP BY NUOCSX
HAVING COUNT(DISTINCT GIA) >= 3

/*Câu 45: *Trong 10 khách hàng có doanh số cao nhất, tìm khách hàng có số lần mua hàng nhiều nhất.*/
--Cách 1:
SELECT TOP 1 WITH TIES HD.MAKH, HOTEN, COUNT(SOHD) SOLANMUAHANG
FROM KHACHHANG KH JOIN HOADON HD ON KH.MAKH = HD.MAKH
WHERE HD.MAKH IN(	SELECT TOP 10 MAKH
					FROM KHACHHANG
					ORDER BY DOANHSO DESC)
GROUP BY HD.MAKH, HOTEN
ORDER BY COUNT(*) DESC

--Cách 2:
SELECT TOP 1 WITH TIES HD.MAKH, HOTEN, COUNT(SOHD) SOLANMUAHANG
FROM (	SELECT TOP 10 MAKH, HOTEN
		FROM KHACHHANG
		ORDER BY DOANHSO DESC) TOP10, HOADON HD
WHERE TOP10.MAKH = HD.MAKH
GROUP BY HD.MAKH, HOTEN
ORDER BY COUNT(SOHD) DESC

--Cách 3:
SELECT HD.MAKH, HOTEN, COUNT(*) SOLANMUAHANG
FROM (	SELECT TOP 10 MAKH, HOTEN
		FROM KHACHHANG
		ORDER BY DOANHSO DESC) TOP10, HOADON HD
WHERE TOP10.MAKH = HD.MAKH
GROUP BY HD.MAKH, HOTEN
HAVING COUNT(*) >= ALL (	SELECT COUNT(*)
							FROM (	SELECT TOP 10 MAKH, HOTEN
									FROM KHACHHANG
									ORDER BY DOANHSO DESC) TOP10, HOADON HD
							WHERE TOP10.MAKH = HD.MAKH
							GROUP BY HD.MAKH)