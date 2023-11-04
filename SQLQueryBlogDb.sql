CREATE DATABASE BlogDB

USE BlogDB



CREATE TABLE Categories (
    Id INT IDENTITY PRIMARY KEY,
    [Name] NVARCHAR(50) NOT NULL UNIQUE,
);


CREATE TABLE Tags (
    Id INT IDENTITY PRIMARY KEY,
    [Name] NVARCHAR(50) NOT NULL UNIQUE,
);

CREATE TABLE Users (
    Id INT IDENTITY PRIMARY KEY,
    UserName NVARCHAR(50) NOT NULL UNIQUE,
    FullName NVARCHAR(50) NOT NULL,
	Age INT CHECK(Age > 0 AND Age < 150),
	
);

CREATE TABLE Blogs (
    Id INT IDENTITY PRIMARY KEY,
    Title NVARCHAR(50) NOT NULL CHECK(LEN(Title) BETWEEN 0 AND 50),
	Descrption NVARCHAR(50) NOT NULL,
	IsDeleted BIT,
	UserId INT FOREIGN KEY (UserId) REFERENCES Users(Id),
	CategoryId INT FOREIGN KEY (CategoryId) REFERENCES Categories(Id)
);



CREATE TABLE Comments (
    Id INT IDENTITY PRIMARY KEY,
    Content NVARCHAR(250) NOT NULL CHECK(LEN(Content) BETWEEN 0 AND 250),
	UserId INT FOREIGN KEY (UserId) REFERENCES Users(Id),
	BlogId INT FOREIGN KEY (BlogId) REFERENCES Blogs(Id)
);

CREATE TABLE CategoryTags (
    Id INT IDENTITY PRIMARY KEY,
	CategoryId INT FOREIGN KEY (CategoryId) REFERENCES Categories(Id),
	TagId INT FOREIGN KEY (TagId) REFERENCES Tags(Id)
);


INSERT INTO Categories
VALUES ('category 1'),('category 2'),('category 3'),('category 4')

INSERT INTO Tags
VALUES ('Tag 1'),('Tag 2'),('Tag 3'),('Tag 4')

INSERT INTO Users
VALUES ('user 1','fullname 1',20),('user 2','fullname 2',25),('user 3','fullname 3',30),('user 4','fullname 4',33)

INSERT INTO Blogs
VALUES ('title 1','desc 1',0,1,2),('title 2','desc 2',0,2,2),('title 3','desc 3',0,3,1),('title 4','desc 4',0,2,2)

INSERT INTO Comments
VALUES ('content 1',1,2),('content 2',2,2),('content 3',1,3),('content 4',3,2)

INSERT INTO CategoryTags
VALUES (1,1),(3,2),(1,3),(2,2)



CREATE VIEW CW_GET_Blogs_Data
AS
SELECT b.Title , U.UserName , U.FullName FROM Blogs AS b
INNER JOIN Users AS U
ON b.UserId = U.Id

SELECT * FROM CW_GET_Blogs_Data


CREATE VIEW CW_GET_Blogs_Data
AS
SELECT b.Title , C.Name FROM Blogs AS b
INNER JOIN Categories AS C
ON b.CategoryId = C.Id

SELECT * FROM CW_GET_Blogs_Data


CREATE PROCEDURE User_Comments @userId INT
AS
SELECT * FROM Comments
WHERE Comments.UserId = @userId

--EXEC User_Comments 2

CREATE PROCEDURE User_Blogs @userId INT
AS
SELECT * FROM Blogs
WHERE Blogs.UserId = @userId

-------------- Burdaki iki dene funksiyani men yazmamişdim(daha doğrusu çatdıra bilmemişdim sinifde)
-------------- Indi yazdim praktika olsun deyib. 
CREATE FUNCTION filterBlogsByCategory(@category INT)
RETURNS INT
AS
BEGIN
  DECLARE @blogCount INT 
  SELECT @blogCount = COUNT(*) FROM Blogs
  WHERE Blogs.CategoryId = @category
  RETURN @blogCount
END


CREATE FUNCTION GetUsersBlogTable(@userId INT)
RETURNS TABLE
AS
RETURN
	SELECT B.Id , B.Title , B.Descrption , B.UserId FROM Blogs AS B
	WHERE B.UserId = @userId

-------------------------

Alter TRIGGER TRG_CHANGE_ISDELETED
ON Blogs
INSTEAD OF DELETE
AS
UPDATE Blogs 
SET IsDeleted = 1
Select B.Id, B.Title , B.Descrption , B.IsDeleted FROM Blogs AS B
INNER JOIN deleted AS del
ON B.Id = del.Id


DELETE FROM Blogs
WHERE ID = 1