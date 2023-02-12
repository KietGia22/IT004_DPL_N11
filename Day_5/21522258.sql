﻿CREATE DATABASE QuanLyGiaoVu
USE QuanLyGiaoVu

CREATE TABLE KHOA
(
   MAKHOA   varchar(4),
   TENKHOA  varchar(40),
   TGTLAP   smalldatetime,
   TRGKHOA char(4),
   CONSTRAINT pk_khoa PRIMARY KEY(MAKHOA)
)

CREATE TABLE MONHOC
(
  MAMH  varchar(10),
  TENMH varchar(40),
  TCLT  tinyint,
  TCTH  tinyint,
  MAKHOA  varchar(4),
  CONSTRAINT pk_monhoc PRIMARY KEY(MAMH)
)

CREATE TABLE DIEUKIEN
(
  MAMH  varchar(10),
  MAMH_TRUOC varchar(10),
  CONSTRAINT pk_dk PRIMARY KEY(MAMH, MAMH_TRUOC)
)

CREATE TABLE GIAOVIEN
(
  MAGV     char(4),
  HOTEN    varchar(40),
  HOCVI    varchar(10),
  HOCHAM   varchar(10),
  GIOITINH varchar(3),
  NGSINH   smalldatetime,
  NGVL     smalldatetime,
  HESO     numeric(4,2),
  MUCLUONG money,
  MAKHOA   varchar(4),
  CONSTRAINT pk_gv PRIMARY KEY(MAGV)
)

CREATE TABLE LOP
(
  MALOP   char(3),
  TENLOP  varchar(40),
  TRGLOP  char(5),
  SISO    tinyint,
  MAGVCN  char(4),
  CONSTRAINT pk_lop PRIMARY KEY(MALOP)
)

CREATE TABLE HOCVIEN
(
  MAHV     char(5),
  HO       varchar(40),
  TEN      varchar(10), 
  NGSINH   smalldatetime,
  GIOITINH varchar(3),
  NOISINH  varchar(40),
  MALOP    char(3)
  CONSTRAINT pk_hv PRIMARY KEY(MAHV)
)

CREATE TABLE GIANGDAY
(
  MALOP    char(3),
  MAMH     varchar(10),
  MAGV     char(4),
  HOCKY    tinyint,
  NAM      smallint,
  TUNGAY   smalldatetime,
  DENNGAY  smalldatetime,
  CONSTRAINT pk_gd PRIMARY KEY(MALOP, MAMH)
)

CREATE TABLE KETQUATHI
(
   MAHV   char(5),
   MAMH   varchar(10),
   LANTHI tinyint,
   NGTHI  smalldatetime,
   DIEM   numeric(4,2),
   KQUA   varchar(10),
   CONSTRAINT pk_kqt PRIMARY KEY(MAHV, MAMH, LANTHI)
)

--KHOA NGOAI
--KHOA
ALTER TABLE KHOA ADD CONSTRAINT fk1_k FOREIGN KEY(TRGKHOA) REFERENCES GIAOVIEN(MAGV)
--MON HOC
ALTER TABLE MONHOC ADD CONSTRAINT fk2_mh FOREIGN KEY(MAKHOA) REFERENCES KHOA(MAKHOA)
--DIEUKIEN
ALTER TABLE DIEUKIEN ADD CONSTRAINT fk3_dk FOREIGN KEY(MAMH) REFERENCES MONHOC(MAMH)
ALTER TABLE DIEUKIEN ADD CONSTRAINT fk4_dk FOREIGN KEY(MAMH_TRUOC) REFERENCES MONHOC(MAMH)
--GIAOVIEN
ALTER TABLE GIAOVIEN ADD CONSTRAINT fk1_gv FOREIGN KEY(MAKHOA) REFERENCES KHOA(MAKHOA)
--LOP
ALTER TABLE LOP ADD CONSTRAINT fk1_lop FOREIGN KEY(TRGLOP) REFERENCES HOCVIEN(MAHV)
ALTER TABLE LOP ADD CONSTRAINT fk2_lop FOREIGN KEY(MAGVCN) REFERENCES GIAOVIEN(MAGV)
--HOC VIEN
ALTER TABLE HOCVIEN ADD CONSTRAINT fk1_hv FOREIGN KEY(MALOP) REFERENCES LOP(MALOP)
--GIANGDAY
ALTER TABLE GIANGDAY ADD CONSTRAINT fk1_gd FOREIGN KEY (MALOP) REFERENCES LOP(MALOP)
ALTER TABLE GIANGDAY ADD CONSTRAINT fk2_gd FOREIGN KEY (MAMH) REFERENCES MONHOC(MAMH)
ALTER TABLE GIANGDAY ADD CONSTRAINT fk3_gd FOREIGN KEY (MAGV) REFERENCES GIAOVIEN(MAGV)
--KET QUA THI
ALTER TABLE KETQUATHI ADD CONSTRAINT fk1_thi FOREIGN KEY (MAHV) REFERENCES HOCVIEN(MAHV)
ALTER TABLE KETQUATHI ADD CONSTRAINT fk2_thi FOREIGN KEY (MAMH) REFERENCES MONHOC(MAMH)

-- Nhap lieu
ALTER TABLE KHOA NOCHECK CONSTRAINT ALL
ALTER TABLE LOP NOCHECK CONSTRAINT ALL
ALTER TABLE MONHOC NOCHECK CONSTRAINT ALL
ALTER TABLE DIEUKIEN NOCHECK CONSTRAINT ALL
ALTER TABLE GIAOVIEN NOCHECK CONSTRAINT ALL
ALTER TABLE HOCVIEN NOCHECK CONSTRAINT ALL
ALTER TABLE GIANGDAY NOCHECK CONSTRAINT ALL
ALTER TABLE KETQUATHI NOCHECK CONSTRAINT ALL

delete from KHOA
delete from LOP
delete from MONHOC
delete from DIEUKIEN
delete from GIAOVIEN
delete from HOCVIEN
delete from GIANGDAY
delete from KETQUATHI

SET DATEFORMAT DMY
-- KHOA
INSERT INTO KHOA VALUES('KHMT','Khoa hoc may tinh','06/07/2005','GV01')
INSERT INTO KHOA VALUES('HTTT','He thong thong tin','06/07/2005','GV02')
INSERT INTO KHOA VALUES('CNPM','Cong nghe phan mem','06/07/2005','GV04')
INSERT INTO KHOA VALUES('MTT','Mang va truyen thong','20/10/2005','GV03')
INSERT INTO KHOA VALUES('KTMT','Ky thuat may tinh','20/12/2005','Null')

-- LOP
INSERT INTO LOP VALUES('K11','Lop 1 khoa 1','K1108',11,'GV07')
INSERT INTO LOP VALUES('K12','Lop 2 khoa 1','K1205',12,'GV09')
INSERT INTO LOP VALUES('K13','Lop 3 khoa 1','K1305',12,'GV14')

-- MONHOC
INSERT INTO MONHOC VALUES('THDC','Tin hoc dai cuong',4,1,'KHMT')
INSERT INTO MONHOC VALUES('CTRR','Cau truc roi rac',5,0,'KHMT')
INSERT INTO MONHOC VALUES('CSDL','Co so du lieu',3,1,'HTTT')
INSERT INTO MONHOC VALUES('CTDLGT','Cau truc du lieu va giai thuat',3,1,'KHMT')
INSERT INTO MONHOC VALUES('PTTKTT','Phan tich thiet ke thuat toan',3,0,'KHMT')
INSERT INTO MONHOC VALUES('DHMT','Do hoa may tinh',3,1,'KHMT')
INSERT INTO MONHOC VALUES('KTMT','Kien truc may tinh',3,0,'KTMT')
INSERT INTO MONHOC VALUES('TKCSDL','Thiet ke co so du lieu',3,1,'HTTT')
INSERT INTO MONHOC VALUES('PTTKHTTT','Phan tich thiet ke he thong thong tin',4,1,'HTTT')
INSERT INTO MONHOC VALUES('HDH','He dieu hanh',4,0,'KTMT')
INSERT INTO MONHOC VALUES('NMCNPM','Nhap mon cong nghe phan mem',3,0,'CNPM')
INSERT INTO MONHOC VALUES('LTCFW','Lap trinh C for win',3,1,'CNPM')
INSERT INTO MONHOC VALUES('LTHDT','Lap trinh huong doi tuong',3,1,'CNPM')

-- DIEUKIEN
INSERT INTO DIEUKIEN VALUES('CSDL','CTRR')
INSERT INTO DIEUKIEN VALUES('CSDL','CTDLGT')
INSERT INTO DIEUKIEN VALUES('CTDLGT','THDC')
INSERT INTO DIEUKIEN VALUES('PTTKTT','THDC')
INSERT INTO DIEUKIEN VALUES('PTTKTT','CTDLGT')
INSERT INTO DIEUKIEN VALUES('DHMT','THDC')
INSERT INTO DIEUKIEN VALUES('LTHDT','THDC')
INSERT INTO DIEUKIEN VALUES('PTTKHTTT','CSDL')

-- GIAOVIEN
INSERT INTO GIAOVIEN VALUES('GV01','Ho Thanh Son','PTS','GS','Nam','05/02/1950','01/11/2004',5,2250000,'KHMT')
INSERT INTO GIAOVIEN VALUES('GV02','Tran Tam Thanh','TS','PGS','Nam','17/12/1965','20/4/2004',4.5,2025000,'HTTT')
INSERT INTO GIAOVIEN VALUES('GV03','Do Nghiem Phung','TS','GS','Nu','08/01/1950','23/9/2004',4,1800000,'CNPM')
INSERT INTO GIAOVIEN VALUES('GV04','Tran Nam Son','TS','PGS','Nam','22/2/1961','01/12/2005',4.5,2025000,'KTMT')
INSERT INTO GIAOVIEN VALUES('GV05','Mai Thanh Danh','ThS','GV','Nam','03/12/1958','01/12/2005',3,1350000,'HTTT')
INSERT INTO GIAOVIEN VALUES('GV06','Tran Doan Hung','TS','GV','Nam','03/11/1953','01/12/2005',4.5,2025000,'KHMT')
INSERT INTO GIAOVIEN VALUES('GV07','Nguyen Minh Tien','ThS','GV','Nam','23/11/1971','03/01/2005',4,1800000,'KHMT')
INSERT INTO GIAOVIEN VALUES('GV08','Le Thi Tran','KS','Null','Nu','26/3/1974','03/01/2005',1.69,760500,'KHMT')
INSERT INTO GIAOVIEN VALUES('GV09','Nguyen To Lan','ThS','GV','Nu','31/12/1966','03/01/2005',4,1800000,'HTTT')
INSERT INTO GIAOVIEN VALUES('GV10','Le Tran Anh Loan','KS','Null','Nu','17/7/1972','03/01/2005',1.86,837000,'CNPM')
INSERT INTO GIAOVIEN VALUES('GV11','Ho Thanh Tung','CN','GV','Nam','01/12/1980','15/5/2005',2.67,1201500,'MTT')
INSERT INTO GIAOVIEN VALUES('GV12','Tran Van Anh','CN','Null','Nu','29/3/1981','15/5/2005',1.69,760500,'CNPM')
INSERT INTO GIAOVIEN VALUES('GV13','Nguyen Linh Dan','CN','Null','Nu','23/5/1980','15/5/2005',1.69,760500,'KTMT')
INSERT INTO GIAOVIEN VALUES('GV14','Truong Minh Chau','ThS','GV','Nu','30/11/1976','15/5/2005',3,1350000,'MTT')
INSERT INTO GIAOVIEN VALUES('GV15','Le Ha Thanh','ThS','GV','Nam','05/04/1978','15/5/2005',3,1350000,'KHMT')

-- HOCVIEN
INSERT INTO HOCVIEN VALUES('K1101','Nguyen Van','A','27/1/1986','Nam','TpHCM','K11')
INSERT INTO HOCVIEN VALUES('K1102','Tran Ngoc','Han','14/3/1986','Nu','Kien Giang','K11')
INSERT INTO HOCVIEN VALUES('K1103','Ha Duy','Lap','18/4/1986','Nam','Nghe An','K11')
INSERT INTO HOCVIEN VALUES('K1104','Tran Ngoc','Linh','30/3/1986','Nu','Tay Ninh','K11')
INSERT INTO HOCVIEN VALUES('K1105','Tran Minh','Long','27/2/1986','Nam','TpHCM','K11')
INSERT INTO HOCVIEN VALUES('K1106','Le Nhat','Minh','24/1/1986','Nam','TpHCM','K11')
INSERT INTO HOCVIEN VALUES('K1107','Nguyen Nhu','Nhut','27/1/1986','Nam','Ha Noi','K11')
INSERT INTO HOCVIEN VALUES('K1108','Nguyen Manh','Tam','27/2/1986','Nam','Kien Giang','K11')
INSERT INTO HOCVIEN VALUES('K1109','Phan Thi Thanh','Tam','27/1/1986','Nu','Vinh Long','K11')
INSERT INTO HOCVIEN VALUES('K1110','Le Hoai','Thuong','02/05/1986','Nu','Can Tho','K11')
INSERT INTO HOCVIEN VALUES('K1111','Le Ha','Vinh','25/12/1986','Nam','Vinh Long','K11')
INSERT INTO HOCVIEN VALUES('K1201','Nguyen Van','B','02/11/1986','Nam','TpHCM','K12')
INSERT INTO HOCVIEN VALUES('K1202','Nguyen Thi Kim','Duyen','18/1/1986','Nu','TpHCM','K12')
INSERT INTO HOCVIEN VALUES('K1203','Tran Thi Kim','Duyen','17/9/1986','Nu','TpHCM','K12')
INSERT INTO HOCVIEN VALUES('K1204','Truong My','Hanh','19/5/1986','Nu','Dong Nai','K12')
INSERT INTO HOCVIEN VALUES('K1205','Nguyen Thanh','Nam','17/4/1986','Nam','TpHCM','K12')
INSERT INTO HOCVIEN VALUES('K1206','Nguyen Thi Truc','Thanh','03/04/1986','Nu','Kien Giang','K12')
INSERT INTO HOCVIEN VALUES('K1207','Tran Thi Bich','Thuy','02/08/1986','Nu','Nghe An','K12')
INSERT INTO HOCVIEN VALUES('K1208','Huynh Thi Kim','Trieu','04/08/1986','Nu','Tay Ninh','K12')
INSERT INTO HOCVIEN VALUES('K1209','Pham Thanh','Trieu','23/2/1986','Nam','TpHCM','K12')
INSERT INTO HOCVIEN VALUES('K1210','Ngo Thanh','Tuan','14/2/1986','Nam','TpHCM','K12')
INSERT INTO HOCVIEN VALUES('K1211','Do Thi','Xuan','03/09/1986','Nu','Ha Noi','K12')
INSERT INTO HOCVIEN VALUES('K1212','Le Thi Phi','Yen','03/12/1986','Nu','TpHCM','K12')
INSERT INTO HOCVIEN VALUES('K1301','Nguyen Thi Kim','Cuc','06/09/1986','Nu','Kien Giang','K13')
INSERT INTO HOCVIEN VALUES('K1302','Truong Thi My','Hien','18/3/1986','Nu','Nghe An','K13')
INSERT INTO HOCVIEN VALUES('K1303','Le Duc','Hien','21/3/1986','Nam','Tay Ninh','K13')
INSERT INTO HOCVIEN VALUES('K1304','Le Quang','Hien','18/4/1986','Nam','TpHCM','K13')
INSERT INTO HOCVIEN VALUES('K1305','Le Thi','Huong','27/3/1986','Nu','TpHCM','K13')
INSERT INTO HOCVIEN VALUES('K1306','Nguyen Thai','Huu','30/3/1986','Nam','Ha Noi','K13')
INSERT INTO HOCVIEN VALUES('K1307','Tran Minh','Man','28/5/1986','Nam','TpHCM','K13')
INSERT INTO HOCVIEN VALUES('K1308','Nguyen Hieu','Nghia','04/08/1986','Nam','Kien Giang','K13')
INSERT INTO HOCVIEN VALUES('K1309','Nguyen Trung','Nghia','18/1/1987','Nam','Nghe An','K13')
INSERT INTO HOCVIEN VALUES('K1310','Tran Thi Hong','Tham','22/4/1986','Nu','Tay Ninh','K13')
INSERT INTO HOCVIEN VALUES('K1311','Tran Minh','Thuc','04/04/1986','Nam','TpHCM','K13')
INSERT INTO HOCVIEN VALUES('K1312','Nguyen Thi Kim','Yen','09/07/1986','Nu','TpHCM','K13')

-- GIANGDAY
INSERT INTO GIANGDAY VALUES('K11','THDC','GV07',1,2006,'01/02/2006','05/12/2006')
INSERT INTO GIANGDAY VALUES('K12','THDC','GV06',1,2006,'01/02/2006','05/12/2006')
INSERT INTO GIANGDAY VALUES('K13','THDC','GV15',1,2006,'01/02/2006','05/12/2006')
INSERT INTO GIANGDAY VALUES('K11','CTRR','GV02',1,2006,'09/01/2006','17/5/2006')
INSERT INTO GIANGDAY VALUES('K12','CTRR','GV02',1,2006,'09/01/2006','17/5/2006')
INSERT INTO GIANGDAY VALUES('K13','CTRR','GV08',1,2006,'09/01/2006','17/5/2006')
INSERT INTO GIANGDAY VALUES('K11','CSDL','GV05',2,2006,'06/01/2006','15/7/2006')
INSERT INTO GIANGDAY VALUES('K12','CSDL','GV09',2,2006,'06/01/2006','15/7/2006')
INSERT INTO GIANGDAY VALUES('K13','CTDLGT','GV15',2,2006,'06/01/2006','15/7/2006')
INSERT INTO GIANGDAY VALUES('K13','CSDL','GV05',3,2006,'08/01/2006','15/12/2006')
INSERT INTO GIANGDAY VALUES('K13','DHMT','GV07',3,2006,'08/01/2006','15/12/2006')
INSERT INTO GIANGDAY VALUES('K11','CTDLGT','GV15',3,2006,'08/01/2006','15/12/2006')
INSERT INTO GIANGDAY VALUES('K12','CTDLGT','GV15',3,2006,'08/01/2006','15/12/2006')
INSERT INTO GIANGDAY VALUES('K11','HDH','GV04',1,2007,'01/02/2007','18/2/2007')
INSERT INTO GIANGDAY VALUES('K12','HDH','GV04',1,2007,'01/02/2007','20/3/2007')
INSERT INTO GIANGDAY VALUES('K11','DHMT','GV07',1,2007,'18/2/2007','20/3/2007')

-- KETQUATHI
INSERT INTO KETQUATHI VALUES('K1101','CSDL',1,'20/7/2006',10,'Dat')
INSERT INTO KETQUATHI VALUES('K1101','CTDLGT',1,'28/12/2006',9,'Dat')
INSERT INTO KETQUATHI VALUES('K1101','THDC',1,'20/5/2006',9,'Dat')
INSERT INTO KETQUATHI VALUES('K1101','CTRR',1,'13/5/2006',9.5,'Dat')
INSERT INTO KETQUATHI VALUES('K1102','CSDL',1,'20/7/2006',4,'Khong Dat')
INSERT INTO KETQUATHI VALUES('K1102','CSDL',2,'27/7/2006',4.25,'Khong Dat')
INSERT INTO KETQUATHI VALUES('K1102','CSDL',3,'08/10/2006',4.5,'Khong Dat')
INSERT INTO KETQUATHI VALUES('K1102','CTDLGT',1,'28/12/2006',4.5,'Khong Dat')
INSERT INTO KETQUATHI VALUES('K1102','CTDLGT',2,'01/05/2007',4,'Khong Dat')
INSERT INTO KETQUATHI VALUES('K1102','CTDLGT',3,'15/1/2007',6,'Dat')
INSERT INTO KETQUATHI VALUES('K1102','THDC',1,'20/5/2006',5,'Dat')
INSERT INTO KETQUATHI VALUES('K1102','CTRR',1,'13/5/2006',7,'Dat')
INSERT INTO KETQUATHI VALUES('K1103','CSDL',1,'20/7/2006',3.5,'Khong Dat')
INSERT INTO KETQUATHI VALUES('K1103','CSDL',2,'27/7/2006',8.25,'Dat')
INSERT INTO KETQUATHI VALUES('K1103','CTDLGT',1,'28/12/2006',7,'Dat')
INSERT INTO KETQUATHI VALUES('K1103','THDC',1,'20/5/2006',8,'Dat')
INSERT INTO KETQUATHI VALUES('K1103','CTRR',1,'13/5/2006',6.5,'Dat')
INSERT INTO KETQUATHI VALUES('K1104','CSDL',1,'20/7/2006',3.75,'Khong Dat')
INSERT INTO KETQUATHI VALUES('K1104','CTDLGT',1,'28/12/2006',4,'Khong Dat')
INSERT INTO KETQUATHI VALUES('K1104','THDC',1,'20/5/2006',4,'Khong Dat')
INSERT INTO KETQUATHI VALUES('K1104','CTRR',1,'13/5/2006',4,'Khong Dat')
INSERT INTO KETQUATHI VALUES('K1104','CTRR',2,'20/5/2006',3.5,'Khong Dat')
INSERT INTO KETQUATHI VALUES('K1104','CTRR',3,'30/6/2006',4,'Khong Dat')
INSERT INTO KETQUATHI VALUES('K1201','CSDL',1,'20/7/2006',6,'Dat')
INSERT INTO KETQUATHI VALUES('K1201','CTDLGT',1,'28/12/2006',5,'Dat')
INSERT INTO KETQUATHI VALUES('K1201','THDC',1,'20/5/2006',8.5,'Dat')
INSERT INTO KETQUATHI VALUES('K1201','CTRR',1,'13/5/2006',9,'Dat')
INSERT INTO KETQUATHI VALUES('K1202','CSDL',1,'20/7/2006',8,'Dat')
INSERT INTO KETQUATHI VALUES('K1202','CTDLGT',1,'28/12/2006',4,'Khong Dat')
INSERT INTO KETQUATHI VALUES('K1202','CTDLGT',2,'01/05/2007',5,'Dat')
INSERT INTO KETQUATHI VALUES('K1202','THDC',1,'20/5/2006',4,'Khong Dat')
INSERT INTO KETQUATHI VALUES('K1202','THDC',2,'27/5/2006',4,'Khong Dat')
INSERT INTO KETQUATHI VALUES('K1202','CTRR',1,'13/5/2006',3,'Khong Dat')
INSERT INTO KETQUATHI VALUES('K1202','CTRR',2,'20/5/2006',4,'Khong Dat')
INSERT INTO KETQUATHI VALUES('K1202','CTRR',3,'30/6/2006',6.25,'Dat')
INSERT INTO KETQUATHI VALUES('K1203','CSDL',1,'20/7/2006',9.25,'Dat')
INSERT INTO KETQUATHI VALUES('K1203','CTDLGT',1,'28/12/2006',9.5,'Dat')
INSERT INTO KETQUATHI VALUES('K1203','THDC',1,'20/5/2006',10,'Dat')
INSERT INTO KETQUATHI VALUES('K1203','CTRR',1,'13/5/2006',10,'Dat')
INSERT INTO KETQUATHI VALUES('K1204','CSDL',1,'20/7/2006',8.5,'Dat')
INSERT INTO KETQUATHI VALUES('K1204','CTDLGT',1,'28/12/2006',6.75,'Dat')
INSERT INTO KETQUATHI VALUES('K1204','THDC',1,'20/5/2006',4,'Khong Dat')
INSERT INTO KETQUATHI VALUES('K1204','CTRR',1,'13/5/2006',6,'Dat')
INSERT INTO KETQUATHI VALUES('K1301','CSDL',1,'20/12/2006',4.25,'Khong Dat')
INSERT INTO KETQUATHI VALUES('K1301','CTDLGT',1,'25/7/2006',8,'Dat')
INSERT INTO KETQUATHI VALUES('K1301','THDC',1,'20/5/2006',7.75,'Dat')
INSERT INTO KETQUATHI VALUES('K1301','CTRR',1,'13/5/2006',8,'Dat')
INSERT INTO KETQUATHI VALUES('K1302','CSDL',1,'20/12/2006',6.75,'Dat')
INSERT INTO KETQUATHI VALUES('K1302','CTDLGT',1,'25/7/2006',5,'Dat')
INSERT INTO KETQUATHI VALUES('K1302','THDC',1,'20/5/2006',8,'Dat')
INSERT INTO KETQUATHI VALUES('K1302','CTRR',1,'13/5/2006',8.5,'Dat')
INSERT INTO KETQUATHI VALUES('K1303','CSDL',1,'20/12/2006',4,'Khong Dat')
INSERT INTO KETQUATHI VALUES('K1303','CTDLGT',1,'25/7/2006',4.5,'Khong Dat')
INSERT INTO KETQUATHI VALUES('K1303','CTDLGT',2,'08/07/2006',4,'Khong Dat')
INSERT INTO KETQUATHI VALUES('K1303','CTDLGT',3,'15/8/2006',4.25,'Khong Dat')
INSERT INTO KETQUATHI VALUES('K1303','THDC',1,'20/5/2006',4.5,'Khong Dat')
INSERT INTO KETQUATHI VALUES('K1303','CTRR',1,'13/5/2006',3.25,'Khong Dat')
INSERT INTO KETQUATHI VALUES('K1303','CTRR',2,'20/5/2006',5,'Dat')
INSERT INTO KETQUATHI VALUES('K1304','CSDL',1,'20/12/2006',7.75,'Dat')
INSERT INTO KETQUATHI VALUES('K1304','CTDLGT',1,'25/7/2006',9.75,'Dat')
INSERT INTO KETQUATHI VALUES('K1304','THDC',1,'20/5/2006',5.5,'Dat')
INSERT INTO KETQUATHI VALUES('K1304','CTRR',1,'13/5/2006',5,'Dat')
INSERT INTO KETQUATHI VALUES('K1305','CSDL',1,'20/12/2006',9.25,'Dat')
INSERT INTO KETQUATHI VALUES('K1305','CTDLGT',1,'25/7/2006',10,'Dat')
INSERT INTO KETQUATHI VALUES('K1305','THDC',1,'20/5/2006',8,'Dat')
INSERT INTO KETQUATHI VALUES('K1305','CTRR',1,'13/5/2006',10,'Dat')

-----------------
--I/Data Definition Language
--Thêm vào 3 thuộc tính GHICHU, DIEMTB, XEPLOAI cho quan hệ HOCVIEN.
ALTER TABLE HOCVIEN
ADD GHICHU varchar(20)

ALTER TABLE HOCVIEN 
ADD XEPLOAI varchar(5)

ALTER TABLE HOCVIEN
ADD DIEMTB varchar(20)

ALTER TABLE HOCVIEN
ALTER COLUMN DIEMTB numeric(4,2)

--I.3
--Thuộc tính GIOITINH chỉ có giá trị là “Nam” hoặc “Nu”.
ALTER TABLE HOCVIEN
ADD CONSTRAINT Check_gt
CHECK (GIOITINH in ('Nam', 'Nu'))

ALTER TABLE GIAOVIEN
ADD CONSTRAINT Check_gt_gv
CHECK (GIOITINH in ('Nam', 'Nu'))

--I.4
--Điểm số của một lần thi có giá trị từ 0 đến 10 và cần lưu đến 2 số lẽ (VD: 6.22).
ALTER TABLE KETQUATHI
ADD CONSTRAINT Check_diem
CHECK (DIEM BETWEEN 0 AND 10)

--I.5
--Kết quả thi là “Dat” nếu điểm từ 5 đến 10 và “Khong dat” nếu điểm nhỏ hơn 5.
ALTER TABLE KETQUATHI
ADD CONSTRAINT Check_kq
CHECK (((DIEM BETWEEN 5 AND 10) AND KQUA = 'Dat') OR ((DIEM < 5) AND KQUA = 'Khong dat'))

--I.6
--Học viên thi một môn tối đa 3 lần.
ALTER TABLE KETQUATHI
ADD CONSTRAINT Check_lanthi
CHECK (LANTHI BETWEEN 0 AND 3)

--I.11
--Học viên ít nhất là 18 tuổi.
ALTER TABLE HOCVIEN
ADD CONSTRAINT Check_tuoihv
CHECK (YEAR(GETDATE()) - YEAR(NGSINH) >= 18)

--I.12
--Giảng dạy một môn học ngày bắt đầu (TUNGAY) phải nhỏ hơn ngày kết thúc (DENNGAY).
ALTER TABLE GIANGDAY
ADD CONSTRAINT Check_ngay
CHECK (TUNGAY < DENNGAY)

--I.13
--Giáo viên khi vào làm ít nhất là 22 tuổi.
ALTER TABLE GIAOVIEN
ADD CONSTRAINT Check_tuoigv
CHECK (YEAR(GETDATE()) - YEAR(NGSINH) >= 22)

--I.14
ALTER TABLE MONHOC
ADD CONSTRAINT Check_tc
CHECK ((ABS(TCLT - TCTH) <= 3) OR (TCTH = 0))

---------
--II/Data Manipulation Language
--II.1
--Tăng hệ số lương thêm 0.2 cho những giáo viên là trưởng khoa.
UPDATE GIAOVIEN
SET HESO = HESO * 1.2
WHERE MAGV IN ('GV01', 'GV02', 'GV03', 'GV04')

--II.2
--Cập nhật giá trị điểm trung bình tất cả các môn học (DIEMTB) của mỗi học viên 
--(tất cả các môn học đều có hệ số 1 và nếu học viên thi một môn nhiều lần, chỉ lấy điểm của lần thi sau cùng).
UPDATE HOCVIEN
SET DIEMTB = (SELECT AVG(DIEM) 
              FROM KETQUATHI KQ
			  WHERE LANTHI = (SELECT MAX(LANTHI)
			                  FROM KETQUATHI KQ1
							  WHERE KQ1.MAHV = HOCVIEN.MAHV
							  AND KQ1.MAMH = KQ.MAMH
							  GROUP BY MAHV, MAMH)
				GROUP BY MAHV
				HAVING KQ.MAHV = HOCVIEN.MAHV)

--II.3
--Cập nhật giá trị cho cột GHICHU là “Cam thi” đối với trường hợp: học viên có một môn bất kỳ thi
--lần thứ 3 dưới 5 điểm
UPDATE HOCVIEN
SET GHICHU = 'Cam thi'
WHERE MAHV IN (SELECT MAHV
              FROM KETQUATHI
			  WHERE LANTHI = 3
			  AND DIEM < 5)

--II.4
--Cập nhật giá trị cho cột XEPLOAI trong quan hệ HOCVIEN như sau:
--o Nếu DIEMTB >= 9 thì XEPLOAI =”XS”
--o Nếu 8 >= DIEMTB < 9 thì XEPLOAI = “G”
--o Nếu 6.5 <= DIEMTB < 8 thì XEPLOAI = “K”
--o Nếu 5 <= DIEMTB < 6.5 thì XEPLOAI = “TB”
--o Nếu DIEMTB < 5 thì XEPLOAI = ”Y”
UPDATE HOCVIEN
SET XEPLOAI = 'XS'
WHERE DIEMTB >= 9

UPDATE HOCVIEN
SET XEPLOAI = 'G'
WHERE DIEMTB >= 8 AND DIEMTB < 9

UPDATE HOCVIEN
SET XEPLOAI = 'K'
WHERE DIEMTB >= 6.5 AND DIEMTB < 8

UPDATE HOCVIEN
SET XEPLOAI = 'TB'
WHERE DIEMTB >= 5 AND DIEMTB < 6.5

UPDATE HOCVIEN
SET XEPLOAI = 'Y'
WHERE DIEMTB < 5

--------
--III/Ngon ngu truy van du lieu
--III.1
--In ra danh sách (mã học viên, họ tên, ngày sinh, mã lớp) lớp trưởng của các lớp.
SELECT MAHV, HO, TEN, NGSINH, L.MALOP
FROM HOCVIEN HV, LOP L
WHERE L.TRGLOP = HV.MAHV

--III.2
--In ra bảng điểm khi thi (mã học viên, họ tên , lần thi, điểm số) môn CTRR của lớp “K12”, sắp xếp theo tên, họ học viên.
SELECT HV.MAHV, HO, TEN, LANTHI, DIEM
FROM HOCVIEN HV, KETQUATHI KQ
WHERE HV.MAHV = KQ.MAHV
AND MAMH = 'CTRR' 
AND MALOP = 'K12'
ORDER BY TEN, HO

--III.3
--In ra danh sách những học viên (mã học viên, họ tên) và những môn học mà học viên đó thi lần thứ nhất đã đạt
SELECT HV.MAHV, HO, TEN, MAMH
FROM HOCVIEN HV, KETQUATHI KQ
WHERE HV.MAHV = KQ.MAHV
AND LANTHI = 1
AND KQUA = 'Dat' 

--III.4
--In ra danh sách học viên (mã học viên, họ tên) của lớp “K11” thi môn CTRR không đạt (ở lần thi 1).
SELECT HV.MAHV, HO, TEN
FROM HOCVIEN HV, KETQUATHI KQ
WHERE HV.MAHV = KQ.MAHV
AND MALOP = 'K11'
AND MAMH = 'CTRR'
AND LANTHI = 1
AND KQUA = 'Khong dat'

--III.5
--Danh sách học viên (mã học viên, họ tên) của lớp “K” thi môn CTRR không đạt (ở tất cả các lần thi).
SELECT DISTINCT HV.MAHV, HO, TEN
FROM HOCVIEN HV, KETQUATHI KQ
WHERE HV.MAHV = KQ.MAHV
AND MALOP LIKE 'K%'
AND MAMH = 'CTRR'
AND KQUA = 'Khong dat' 
AND LANTHI IN (1,2,3)

SELECT DISTINCT HV.MAHV, HO, TEN
FROM HOCVIEN HV, KETQUATHI KQ
WHERE HV.MAHV = KQ.MAHV
AND MALOP LIKE 'K%'
AND MAMH = 'CTRR'
AND NOT EXISTS 
(
  SELECT MAHV FROM KETQUATHI
  WHERE MAHV = HV.MAHV
  AND MALOP LIKE 'K%'
  AND MAMH = 'CTRR'
  AND KQUA = 'Dat'
)

--III.6
--Tìm tên những môn học mà giáo viên có tên “Tran Tam Thanh” dạy trong học kỳ 1 năm 2006.
SELECT DISTINCT TENMH
FROM MONHOC MH, GIAOVIEN GV, GIANGDAY GD
WHERE MH.MAMH = GD.MAMH
AND GV.MAGV = GD.MAGV
AND HOTEN = 'Tran Tam Thanh'
AND HOCKY = 1
AND NAM = 2006

--III.7
--Tìm những môn học (mã môn học, tên môn học) mà giáo viên chủ nhiệm lớp “K11” dạy trong học kỳ 1 năm 2006.
SELECT MH.MAMH, TENMH
FROM MONHOC MH, GIANGDAY GD
WHERE MH.MAMH = GD.MAMH
AND HOCKY = 1
AND NAM = 2006
AND MAGV IN (SELECT MAGVCN
             FROM LOP
			 WHERE MALOP = 'K11')

--III.8
--Tìm họ tên lớp trưởng của các lớp mà giáo viên có tên “Nguyen To Lan” dạy môn “Co So Du Lieu”
SELECT HO, TEN
FROM HOCVIEN HV, LOP L, GIANGDAY GD, GIAOVIEN GV, MONHOC MH
WHERE HV.MAHV = L.TRGLOP
AND L.MALOP = GD.MALOP
AND GD.MAGV = GV.MAGV
AND GV.MAKHOA = MH.MAKHOA
AND HOTEN = 'Nguyen To Lan'
AND TENMH = 'Co so du lieu'

--III.9
--In ra danh sách những môn học (mã môn học, tên môn học) phải học liền trước môn “Co So Du Lieu”.
SELECT MAMH, TENMH
FROM MONHOC
WHERE MAMH IN (SELECT MAMH_TRUOC
               FROM DIEUKIEN DK, MONHOC MH
			   WHERE DK.MAMH = MH.MAMH
			   AND TENMH = 'Co so du lieu'
			   )

--III.10
--Môn “Cau Truc Roi Rac” là môn bắt buộc phải học liền trước những môn học (mã môn học, tên
--môn học) nào.
SELECT MH.MAMH, TENMH
FROM MONHOC MH, DIEUKIEN DK
WHERE MH.MAMH = DK.MAMH
AND DK.MAMH_TRUOC = 'CTRR'

--III.11
--Tìm họ tên giáo viên dạy môn CTRR cho cả hai lớp “K11” và “K12” trong cùng học kỳ 1 năm 2006.
SELECT HOTEN
FROM GIAOVIEN GV, GIANGDAY GD
WHERE GV.MAGV = GD.MAGV
AND MALOP = 'K11'
AND MAMH = 'CTRR'
AND HOCKY = 1
AND NAM = 2006
INTERSECT
SELECT HOTEN
FROM GIAOVIEN GV, GIANGDAY GD
WHERE GV.MAGV = GD.MAGV
AND MALOP = 'K12'
AND MAMH = 'CTRR'
AND HOCKY = 1
AND NAM = 2006

--III.12
SELECT HV.MAHV, HO, TEN
FROM HOCVIEN HV, KETQUATHI KQ
WHERE HV.MAHV = KQ.MAHV
AND LANTHI = 1
AND MAMH = 'CSDL'
AND KQUA= 'Khong Dat'
AND HV.MAHV NOT IN ( SELECT DISTINCT MAHV
                     FROM KETQUATHI
					 WHERE LANTHI >= 2
					 AND MAMH = 'CSDL')

--III.13
--Tìm giáo viên (mã giáo viên, họ tên) không được phân công giảng dạy bất kỳ môn học nào.
SELECT MAGV, HOTEN
FROM GIAOVIEN
EXCEPT 
SELECT GV.MAGV, HOTEN
FROM GIAOVIEN GV, GIANGDAY GD
WHERE GV.MAGV = GD.MAGV

--C2
SELECT MAGV, HOTEN
FROM GIAOVIEN
WHERE MAGV NOT IN ( SELECT MAGV  
                    FROM GIANGDAY)


--III.14
--Tìm giáo viên (mã giáo viên, họ tên) không được phân công giảng dạy bất kỳ môn học nào thuộc
--khoa giáo viên đó phụ trách.
SELECT  GV.MAGV, HOTEN
FROM GIAOVIEN GV
WHERE GV.MAGV NOT IN ( SELECT MAGV
                    FROM GIANGDAY, MONHOC
					WHERE GIANGDAY.MAMH = MONHOC.MAMH
					AND MONHOC.MAKHOA = GV.MAKHOA)

--Tìm giáo viên (mã giáo viên, họ tên) được phân công giảng dạy bất kỳ môn học nào thuộc
--khoa giáo viên đó phụ trách.
SELECT GV.MAGV, HOTEN
FROM GIAOVIEN GV
WHERE MAGV IN ( SELECT MAGV
               FROM GIANGDAY, MONHOC
			   WHERE GIANGDAY.MAMH = MONHOC.MAMH
			   AND MONHOC.MAKHOA = GV.MAKHOA)

---III.15
--Tìm họ tên các học viên thuộc lớp “K11” thi một môn bất kỳ quá 3 lần vẫn “Khong dat” hoặc thi lần
--thứ 2 môn CTRR được 5 điểm.
SELECT HO, TEN 
FROM HOCVIEN, KETQUATHI
WHERE MALOP = 'K11'
AND LANTHI >= 3
AND KQUA = 'Khong Dat'
UNION
SELECT HO, TEN 
FROM HOCVIEN, KETQUATHI
WHERE MALOP = 'K11'
AND LANTHI = 2
AND MAMH = 'CTRR'
AND DIEM = 5

--III.16
--Tìm họ tên giáo viên dạy môn CTRR cho ít nhất hai lớp trong cùng một học kỳ của một năm học.
SELECT HOTEN
FROM GIAOVIEN GV, GIANGDAY GD
WHERE GV.MAGV = GD.MAGV
AND MAMH = 'CTRR'
GROUP BY HOTEN, HOCKY, NAM
HAVING COUNT(MALOP) >= 2

--III.17
--Danh sách học viên và điểm thi môn CSDL (chỉ lấy điểm của lần thi sau cùng).
SELECT KQ.MAHV, HO, TEN, DIEM
FROM KETQUATHI KQ, HOCVIEN HV
WHERE KQ.MAHV = HV.MAHV
AND MAMH = 'CSDL'
AND LANTHI >= ALL ( SELECT LANTHI 
                      FROM KETQUATHI KQ1
					  WHERE KQ.MAHV = KQ1.MAHV)

--III.18
--Danh sách học viên và điểm thi môn “Co So Du Lieu” (chỉ lấy điểm cao nhất của các lần thi).
SELECT KQ.MAHV, HO, TEN, DIEM
FROM KETQUATHI KQ, HOCVIEN HV
WHERE KQ.MAHV = HV.MAHV
AND MAMH = 'CSDL'
AND DIEM >= ALL ( SELECT DIEM 
                  FROM KETQUATHI KQ1
				  WHERE KQ.MAHV = KQ1.MAHV)

--III.19
--Khoa nào (mã khoa, tên khoa) được thành lập sớm nhất.
SELECT MAKHOA, TENKHOA
FROM KHOA
WHERE TGTLAP = (SELECT DISTINCT TOP 1 WITH TIES TGTLAP
                 FROM KHOA
				 ORDER BY TGTLAP ASC)

--ngan hon
SELECT TOP 1 WITH TIES MAKHOA, TENKHOA
FROM KHOA
ORDER BY TGTLAP ASC

--III.20
--Có bao nhiêu giáo viên có học hàm là “GS” hoặc “PGS”.
SELECT HOCHAM, COUNT(MAGV) AS HOCHAMGV
FROM GIAOVIEN
WHERE HOCHAM = 'PGS' 
OR HOCHAM = 'GS'
GROUP BY HOCHAM

--III.21
--Thống kê có bao nhiêu giáo viên có học vị là “CN”, “KS”, “Ths”, “TS”, “PTS” trong mỗi khoa.
SELECT MAKHOA, HOCVI, COUNT(MAGV) AS HOCVIGV
FROM GIAOVIEN
GROUP BY MAKHOA, HOCVI

SELECT MAKHOA, COUNT(MAGV) AS HOCVIGV
FROM GIAOVIEN
GROUP BY MAKHOA

--III.22
--Mỗi môn học thống kê số lượng học viên theo kết quả (đạt và không đạt).
SELECT MAMH, KQUA, COUNT(MAHV) AS KQUAHV
FROM KETQUATHI
GROUP BY MAMH, KQUA

SELECT HV.MAHV, HO, TEN, LANTHI, MAMH, KQUA
FROM KETQUATHI KQ, HOCVIEN HV
WHERE KQ.MAHV = HV.MAHV
AND LANTHI IN ('1', '2', '3')
AND EXISTS ( SELECT *
             FROM KETQUATHI KQ1
	    	 WHERE HV.MAHV =  KQ1.MAHV
			 AND KQ.LANTHI = KQ1.LANTHI
			 AND KQUA = 'Dat')
--III.23
--Tìm giáo viên (mã giáo viên, họ tên) là giáo viên chủ nhiệm của một lớp, đồng thời dạy cho lớp đó ít
--nhất một môn học
SELECT GV.MAGV, HOTEN, GD.MALOP, COUNT(MAMH) AS MONGVDAY
FROM GIAOVIEN GV, LOP L, GIANGDAY GD
WHERE GV.MAGV = L.MAGVCN
AND L.MALOP = GD.MALOP
AND GV.MAGV = GD.MAGV
GROUP BY GV.MAGV, HOTEN, GD.MALOP
HAVING COUNT(MAMH) >= 1

--III.24
--Tìm họ tên lớp trưởng của lớp có sỉ số cao nhất.
SELECT HO, TEN, SISO
FROM LOP L, HOCVIEN HV
WHERE L.TRGLOP = HV.MAHV
AND SISO = (SELECT MAX(SISO)
            FROM LOP)

--III.25
--Tìm họ tên những LOPTRG thi không đạt quá 3 môn (mỗi môn đều thi không đạt ở tất cả các lần
--thi).
SELECT HO, TEN, COUNT(DISTINCT MAMH) AS MONKD
FROM HOCVIEN HV, KETQUATHI KQ
WHERE HV.MAHV = KQ.MAHV
AND HV.MAHV IN (SELECT TRGLOP
			    FROM LOP)
AND MAMH IN ( SELECT MAMH
              FROM KETQUATHI KQ1
			  WHERE HV.MAHV = KQ1.MAHV
			  AND KQUA = 'Khong Dat'
			  AND LANTHI = (SELECT MAX(LANTHI)
			                FROM KETQUATHI KQ2
							WHERE HV.MAHV = KQ2.MAHV
							AND KQ.MAMH = KQ2.MAMH)
			  )
GROUP BY HO, TEN
HAVING COUNT(DISTINCT MAMH) >= 3

--III.26
--Tìm học viên (mã học viên, họ tên) có số môn đạt điểm 9,10 nhiều nhất.
SELECT HV.MAHV, HO, TEN, COUNT(MAMH) AS MONHOC
FROM HOCVIEN HV, KETQUATHI KQ
WHERE HV.MAHV = KQ.MAHV
AND DIEM IN ('9', '10')
GROUP BY HV.MAHV, HO, TEN
HAVING COUNT(MAMH) >= ALL (SELECT COUNT(MAMH)
                           FROM KETQUATHI
						   WHERE DIEM IN ('9', '10')
						   GROUP BY MAHV)

--III.27
--Trong từng lớp, tìm học viên (mã học viên, họ tên) có số môn đạt điểm 9,10 nhiều nhất.
SELECT MALOP, HV.MAHV, HO, TEN
FROM HOCVIEN HV, KETQUATHI KQ
WHERE HV.MAHV = KQ.MAHV
AND DIEM IN ('9', '10')
GROUP BY MALOP, HV.MAHV, HO, TEN
HAVING COUNT(MAMH) >= ALL (SELECT COUNT(MAMH)
                           FROM KETQUATHI KQ1, HOCVIEN HV1
						   WHERE HV1.MAHV = KQ1.MAHV
						   AND DIEM IN ('9', '10')
						   AND HV1.MALOP = HV.MALOP
						   GROUP BY HV1.MAHV, MALOP) 

--III.28
--Trong từng học kỳ của từng năm, mỗi giáo viên phân công dạy bao nhiêu môn học, bao nhiêu lớp.
SELECT HOCKY, NAM, GV.MAGV, HOTEN, COUNT(DISTINCT MAMH) AS MONHOC, COUNT(DISTINCT MALOP) AS SOLOP
FROM GIAOVIEN GV, GIANGDAY GD
WHERE GV.MAGV = GD.MAGV
GROUP BY HOCKY, NAM, GV.MAGV, HOTEN

--III.29
--Trong từng học kỳ của từng năm, tìm giáo viên (mã giáo viên, họ tên) giảng dạy nhiều nhất.
SELECT HOCKY, NAM, GV.MAGV, HOTEN, COUNT(DISTINCT MALOP) AS SOLOP
FROM GIAOVIEN GV, GIANGDAY GD
WHERE GV.MAGV = GD.MAGV
GROUP BY  HOCKY, NAM, GV.MAGV, HOTEN
HAVING COUNT(DISTINCT MALOP) >= ALL (SELECT COUNT(DISTINCT MALOP)
                                    FROM GIAOVIEN GV1, GIANGDAY GD1
									WHERE GV1.MAGV = GD1.MAGV
									AND GD.HOCKY = GD1.HOCKY
									AND GD.NAM = GD1.NAM
									GROUP BY GV1.MAGV, HOCKY, NAM)
--III.30
--Tìm môn học (mã môn học, tên môn học) có nhiều học viên thi không đạt (ở lần thi thứ 1) nhất.
SELECT MH.MAMH, TENMH, COUNT(DISTINCT MAHV) AS SLSV
FROM MONHOC MH, KETQUATHI KQ
WHERE LANTHI = 1
AND MH.MAMH = KQ.MAMH
AND KQUA = 'Khong Dat'
GROUP BY MH.MAMH, TENMH
HAVING COUNT(DISTINCT MAHV) >= ALL (SELECT COUNT(DISTINCT MAHV)
                                    FROM KETQUATHI
									WHERE LANTHI = 1
									AND KQUA = 'Khong Dat'
									GROUP BY MAMH)

--C2
SELECT TOP 1 WITH TIES MH.MAMH, TENMH, COUNT(DISTINCT MAHV) AS SLSV
FROM MONHOC MH, KETQUATHI KQ
WHERE MH.MAMH = KQ.MAMH
AND KQUA = 'Khong Dat'
AND LANTHI = 1
GROUP BY MH.MAMH, TENMH
ORDER BY COUNT(DISTINCT MAHV) DESC



