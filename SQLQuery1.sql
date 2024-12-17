CREATE TABLE Userss (
    UserID INT PRIMARY KEY IDENTITY(1,1),
    UserType VARCHAR(20) NOT NULL CHECK (UserType IN ('Advertiser', 'Owner')),
    FirstName VARCHAR(255) NOT NULL,
    LastName VARCHAR(255) NOT NULL,
    Email VARCHAR(255) NOT NULL UNIQUE,
    PasswordHash VARCHAR(255) NOT NULL,
    Phone VARCHAR(20),
    RegistrationDate DATETIME DEFAULT GETDATE(),
    BillingAddress VARCHAR(255),
    Company VARCHAR(255),
    IsVerified BIT DEFAULT 0,
    UNIQUE (Email)
);

CREATE TABLE AdSpaces (
    AdSpaceID INT PRIMARY KEY IDENTITY(1,1),
    OwnerID INT NOT NULL,
    AdType VARCHAR(20) NOT NULL CHECK (AdType IN ('Billboard', 'DigitalScreen', 'BusStop', 'Other')),
    Address VARCHAR(255) NOT NULL,
    Latitude DECIMAL(10, 8) NOT NULL,
    Longitude DECIMAL(11, 8) NOT NULL,
    Description TEXT,
    Dimensions VARCHAR(50),
    Availability BIT DEFAULT 1,
    PricePerDay DECIMAL(10, 2) NOT NULL,
    Images NVARCHAR(MAX),
    FOREIGN KEY (OwnerID) REFERENCES Userss(UserID)
);

CREATE TABLE Bookings (
    BookingID INT PRIMARY KEY IDENTITY(1,1),
    AdvertiserID INT NOT NULL,
    AdSpaceID INT NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    TotalPrice DECIMAL(10, 2) NOT NULL,
    BookingDate DATETIME DEFAULT GETDATE(),
    BookingStatus VARCHAR(20) DEFAULT 'Pending' CHECK (BookingStatus IN ('Pending', 'Confirmed', 'Cancelled')),
    FOREIGN KEY (AdvertiserID) REFERENCES Userss(UserID),
    FOREIGN KEY (AdSpaceID) REFERENCES AdSpaces(AdSpaceID)
);

CREATE TABLE Messages (
  MessageID INT PRIMARY KEY IDENTITY(1,1),
  SenderID INT NOT NULL,
  ReceiverID INT NOT NULL,
  MessageText TEXT NOT NULL,
  SendDate DATETIME DEFAULT GETDATE(),
  FOREIGN KEY (SenderID) REFERENCES Userss(UserID),
  FOREIGN KEY (ReceiverID) REFERENCES Userss(UserID)
);

CREATE TABLE Reviewss (
    ReviewID INT PRIMARY KEY IDENTITY(1,1),
    BookingID INT NOT NULL,
    ReviewerID INT NOT NULL,
    Rating INT NOT NULL,
    Comment TEXT,
    ReviewDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID),
    FOREIGN KEY (ReviewerID) REFERENCES Userss(UserID)
);

CREATE TABLE PlatformSettings (
    SettingName VARCHAR(255) PRIMARY KEY,
    SettingValue VARCHAR(255)
);

CREATE TABLE Images (
  ImageID INT PRIMARY KEY IDENTITY(1,1),
  ImageURL VARCHAR(255) NOT NULL,
  AdSpaceID INT,
  FOREIGN KEY (AdSpaceID) REFERENCES AdSpaces(AdSpaceID)
);

CREATE TABLE Transactions (
  TransactionID INT PRIMARY KEY IDENTITY(1,1),
  BookingID INT NOT NULL,
  TransactionDate DATETIME DEFAULT GETDATE(),
  TransactionType VARCHAR(20) NOT NULL CHECK (TransactionType IN ('Payment', 'Refund')),
  Amount DECIMAL (10,2) NOT NULL,
  PaymentMethod VARCHAR (255),
  TransactionStatus VARCHAR(20) DEFAULT 'Pending' CHECK (TransactionStatus IN ('Success', 'Failed', 'Pending')),
  FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID)
);