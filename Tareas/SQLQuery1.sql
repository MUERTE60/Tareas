
IF EXISTS(SELECT * FROM master.sys.databases 
          WHERE name='TAREA')
BEGIN
	use master;
    Drop database TAREA;
END
GO

Create Database TAREA;
GO

use TAREA;
GO


-- migueljppx@gmail.com  //correo
-- subir tareas a git, y crear carpetas, de cada tareas, y enviar solo enlace.
-- Tarea Dase: debe incluir integridad de datos e integridal referencial
-- extras: indexar datos
-- agregar indice
-- agregar transacciones anidadas



CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY,
    DateOfBirth DATE NOT NULL,
    Name VARCHAR(100) NOT NULL
);

CREATE TABLE Passport (
    PassportID INT PRIMARY KEY,
    Nationality VARCHAR(100) NOT NULL,
    Sex CHAR(1) CHECK (Sex IN ('M', 'F')) NOT NULL,
    IssuedDate DATE NOT NULL,
    ExpiredDate DATE NOT NULL,
    CustomerID INT NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

CREATE TABLE FrequentFlyerCard (
    FFC_Number INT PRIMARY KEY,
    Miles INT NOT NULL CHECK (Miles >= 0),
    Meal_Code VARCHAR(10) NOT NULL,
    CustomerID INT NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

CREATE TABLE Country (
    CountryID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL
);

CREATE TABLE City (
    CityID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    CountryID INT NOT NULL,
    FOREIGN KEY (CountryID) REFERENCES Country(CountryID)
);

CREATE TABLE Airport (
    AirportID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    CityID INT NOT NULL,
    FOREIGN KEY (CityID) REFERENCES City(CityID)
);

CREATE TABLE PlaneModel (
    PlaneModelID INT PRIMARY KEY,
    Description VARCHAR(100) NOT NULL,
    Graphic VARBINARY(MAX)
);

CREATE TABLE Airplane (
    AirplaneID INT PRIMARY KEY,
    RegistrationNumber VARCHAR(50) NOT NULL,
    BeginOfOperation DATE NOT NULL,
    Status VARCHAR(50) NOT NULL,
    PlaneModelID INT NOT NULL,
    FOREIGN KEY (PlaneModelID) REFERENCES PlaneModel(PlaneModelID)
);

CREATE TABLE Ticket (
    TicketID INT PRIMARY KEY,
    TicketingCode VARCHAR(50) NOT NULL,
    CustomerID INT NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

CREATE TABLE FlightNumber (
    FlightNumberID INT PRIMARY KEY,
    DepartureTime DATETIME NOT NULL,
    Description VARCHAR(50) NOT NULL,
    Type VARCHAR(50) NOT NULL,
    Airline VARCHAR(50) NOT NULL,
    StartAirportID INT NOT NULL,
    GoalAirportID INT NOT NULL,
    PlaneModelID INT NOT NULL,
    FOREIGN KEY (StartAirportID) REFERENCES Airport(AirportID),
    FOREIGN KEY (GoalAirportID) REFERENCES Airport(AirportID),
    FOREIGN KEY (PlaneModelID) REFERENCES PlaneModel(PlaneModelID)
);

CREATE TABLE Flight (
    FlightID INT PRIMARY KEY,
    BoardingTime DATETIME NOT NULL,
    FlightDate DATE NOT NULL,
    Gate VARCHAR(50) NOT NULL,
    CheckInCounter VARCHAR(50) NOT NULL,
    FlightNumberID INT NOT NULL,
    FOREIGN KEY (FlightNumberID) REFERENCES FlightNumber(FlightNumberID)
);

CREATE TABLE Seat (
    SeatID INT PRIMARY KEY,
    Size VARCHAR(50) NOT NULL,
    Number INT NOT NULL,
    Location VARCHAR(50) NOT NULL,
    PlaneModelID INT NOT NULL,
    FOREIGN KEY (PlaneModelID) REFERENCES PlaneModel(PlaneModelID)
);

CREATE TABLE AvailableSeat (
    AvailableSeatID INT PRIMARY KEY,
    FlightID INT NOT NULL,
    SeatID INT NOT NULL,
    FOREIGN KEY (FlightID) REFERENCES Flight(FlightID),
    FOREIGN KEY (SeatID) REFERENCES Seat(SeatID)
);

CREATE TABLE Coupon (
    CouponID INT PRIMARY KEY,
    DateOfRedemption DATE NOT NULL,
    Class VARCHAR(50) NOT NULL,
    Standby VARCHAR(50) NOT NULL,
    MealCode VARCHAR(50) NOT NULL,
    TicketID INT NOT NULL,
    FlightID INT NOT NULL,
    FOREIGN KEY (TicketID) REFERENCES Ticket(TicketID),
    FOREIGN KEY (FlightID) REFERENCES Flight(FlightID)
);

CREATE TABLE PiecesOfLuggage (
    LuggageID INT PRIMARY KEY,
    Number INT NOT NULL CHECK (Number > 0),
    Weight DECIMAL(5, 2) NOT NULL CHECK (Weight > 0),
    CouponID INT NOT NULL,
    FOREIGN KEY (CouponID) REFERENCES Coupon(CouponID)
);

CREATE TABLE AvailableCoupon (
    AvailableCouponID INT PRIMARY KEY,
    CouponID INT UNIQUE NOT NULL,
    AvailableSeatID INT UNIQUE NOT NULL,
    FOREIGN KEY (CouponID) REFERENCES Coupon(CouponID),
    FOREIGN KEY (AvailableSeatID) REFERENCES AvailableSeat(AvailableSeatID)
);


CREATE INDEX idx_CustomerID ON Passport(CustomerID);
CREATE INDEX idx_CityID ON Airport(CityID);
CREATE INDEX idx_FlightNumberID ON Flight(FlightNumberID);
CREATE INDEX idx_PlaneModelID ON Seat(PlaneModelID);


BEGIN TRANSACTION;

    BEGIN TRY
        BEGIN TRANSACTION;
        INSERT INTO Customer (CustomerID, DateOfBirth, Name) VALUES 
        (1, '1980-05-12', 'John Doe'),
        (2, '1992-07-23', 'Jane Smith'),
        (3, '1985-11-30', 'Emily Johnson'),
        (4, '1978-03-15', 'Michael Brown'),
        (5, '1995-09-02', 'Jessica Davis'),
        (6, '1983-10-22', 'David Wilson'),
        (7, '1972-12-10', 'Sarah Miller'),
        (8, '1988-01-05', 'Daniel Moore'),
        (9, '1990-02-18', 'Laura Taylor'),
        (10, '1987-04-29', 'James Anderson'),
        (11, '1982-06-17', 'Sophia Thomas'),
        (12, '1993-08-06', 'Christopher Jackson'),
        (13, '1975-09-25', 'Olivia White'),
        (14, '1989-12-14', 'Matthew Harris'),
        (15, '1991-11-03', 'Ashley Clark');
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;

    BEGIN TRY
        BEGIN TRANSACTION;
        INSERT INTO Passport (PassportID, Nationality, Sex, IssuedDate, ExpiredDate, CustomerID) VALUES 
        (1, 'USA', 'M', '2015-05-01', '2025-05-01', 1),
        (2, 'Canada', 'F', '2016-07-01', '2026-07-01', 2),
        (3, 'UK', 'F', '2017-09-01', '2027-09-01', 3),
        (4, 'Australia', 'M', '2014-03-01', '2024-03-01', 4),
        (5, 'France', 'F', '2018-11-01', '2028-11-01', 5),
        (6, 'Germany', 'M', '2016-01-01', '2026-01-01', 6),
        (7, 'Italy', 'F', '2013-12-01', '2023-12-01', 7),
        (8, 'Spain', 'M', '2019-02-01', '2029-02-01', 8),
        (9, 'Brazil', 'F', '2015-04-01', '2025-04-01', 9),
        (10, 'Japan', 'M', '2020-06-01', '2030-06-01', 10),
        (11, 'South Korea', 'F', '2017-08-01', '2027-08-01', 11),
        (12, 'China', 'M', '2016-10-01', '2026-10-01', 12),
        (13, 'Russia', 'F', '2018-12-01', '2028-12-01', 13),
        (14, 'South Africa', 'M', '2021-01-01', '2031-01-01', 14),
        (15, 'Mexico', 'F', '2020-03-01', '2030-03-01', 15);
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;

    BEGIN TRY
        BEGIN TRANSACTION;
        INSERT INTO FrequentFlyerCard (FFC_Number, Miles, Meal_Code, CustomerID) VALUES 
        (1, 12000, 'VGML', 1),
        (2, 15000, 'HNML', 2),
        (3, 20000, 'LCML', 3),
        (4, 18000, 'VGML', 4),
        (5, 22000, 'HNML', 5),
        (6, 17000, 'VGML', 6),
        (7, 16000, 'LCML', 7),
        (8, 14000, 'VGML', 8),
        (9, 19000, 'HNML', 9),
        (10, 21000, 'VGML', 10),
        (11, 23000, 'LCML', 11),
        (12, 25000, 'VGML', 12),
        (13, 24000, 'HNML', 13),
        (14, 26000, 'VGML', 14),
        (15, 27000, 'LCML', 15);
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;

    BEGIN TRY
        BEGIN TRANSACTION;
        INSERT INTO Country (CountryID, Name) VALUES 
        (1, 'United States'),
        (2, 'Canada'),
        (3, 'United Kingdom'),
        (4, 'Australia'),
        (5, 'Germany'),
        (6, 'France'),
        (7, 'Japan'),
        (8, 'China'),
        (9, 'Russia'),
        (10, 'India'),
        (11, 'Brazil'),
        (12, 'South Korea'),
        (13, 'Italy'),
        (14, 'South Africa'),
        (15, 'Spain');
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;

    BEGIN TRY
        BEGIN TRANSACTION;
        INSERT INTO City (CityID, Name, CountryID) VALUES 
        (1, 'New York', 1),
        (2, 'Toronto', 2),
        (3, 'London', 3),
        (4, 'Sydney', 4),
        (5, 'Berlin', 5),
        (6, 'Paris', 6),
        (7, 'Tokyo', 7),
        (8, 'Beijing', 8),
        (9, 'Moscow', 9),
        (10, 'Mumbai', 10),
        (11, 'São Paulo', 11),
        (12, 'Seoul', 12),
        (13, 'Rome', 13),
        (14, 'Cape Town', 14),
        (15, 'Madrid', 15);
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;

    BEGIN TRY
        BEGIN TRANSACTION;
        INSERT INTO Airport (AirportID, Name, CityID) VALUES 
        (1, 'John F. Kennedy International Airport', 1),
        (2, 'Toronto Pearson International Airport', 2),
        (3, 'Heathrow Airport', 3),
        (4, 'Sydney Kingsford Smith Airport', 4),
        (5, 'Berlin Brandenburg Airport', 5),
        (6, 'Charles de Gaulle Airport', 6),
        (7, 'Narita International Airport', 7),
        (8, 'Beijing Capital International Airport', 8),
        (9, 'Sheremetyevo International Airport', 9),
        (10, 'Chhatrapati Shivaji Maharaj International Airport', 10),
        (11, 'São Paulo/Guarulhos International Airport', 11),
        (12, 'Incheon International Airport', 12),
        (13, 'Leonardo da Vinci–Fiumicino Airport', 13),
        (14, 'Cape Town International Airport', 14),
        (15, 'Adolfo Suárez Madrid–Barajas Airport', 15);
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;

    BEGIN TRY
        BEGIN TRANSACTION;
        INSERT INTO PlaneModel (PlaneModelID, Description, Graphic) VALUES 
        (1, 'Boeing 737', NULL),
        (2, 'Airbus A320', NULL),
        (3, 'Boeing 777', NULL),
        (4, 'Airbus A380', NULL),
        (5, 'Boeing 787', NULL),
        (6, 'Airbus A350', NULL),
        (7, 'Boeing 747', NULL),
        (8, 'Embraer E190', NULL),
        (9, 'Bombardier CRJ900', NULL),
        (10, 'Airbus A330', NULL);
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;

    BEGIN TRY
        BEGIN TRANSACTION;
        INSERT INTO Airplane (AirplaneID, RegistrationNumber, BeginOfOperation, Status, PlaneModelID) VALUES 
        (1, 'N737AA', '2015-01-01', 'Active', 1),
        (2, 'C-FABC', '2016-02-15', 'Active', 2),
        (3, 'G-BOAC', '2017-03-20', 'Active', 3),
        (4, 'VH-OQA', '2018-04-25', 'Active', 4),
        (5, 'D-ABUA', '2019-05-30', 'Active', 5),
        (6, 'F-GSTA', '2020-06-10', 'Active', 6),
        (7, 'JA8088', '2021-07-15', 'Active', 7),
        (8, 'PT-TAA', '2022-08-20', 'Active', 8),
        (9, 'C-GFAF', '2023-09-25', 'Active', 9),
        (10, 'EC-MTJ', '2024-10-30', 'Active', 10);
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;

    BEGIN TRY
        BEGIN TRANSACTION;
        INSERT INTO Ticket (TicketID, TicketingCode, CustomerID) VALUES 
        (1, 'ABC123', 1),
        (2, 'DEF456', 2),
        (3, 'GHI789', 3),
        (4, 'JKL012', 4),
        (5, 'MNO345', 5),
        (6, 'PQR678', 6),
        (7, 'STU901', 7),
        (8, 'VWX234', 8),
        (9, 'YZA567', 9),
        (10, 'BCD890', 10),
        (11, 'EFG123', 11),
        (12, 'HIJ456', 12),
        (13, 'KLM789', 13),
        (14, 'NOP012', 14),
        (15, 'QRS345', 15);
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;

    BEGIN TRY
        BEGIN TRANSACTION;
        INSERT INTO FlightNumber (FlightNumberID, DepartureTime, Description, Type, Airline, StartAirportID, GoalAirportID, PlaneModelID) VALUES 
        (1, '2024-01-01 06:00:00', 'Morning Flight', 'Domestic', 'American Airlines', 1, 2, 1),
        (2, '2024-01-02 07:00:00', 'Morning Flight', 'Domestic', 'Air Canada', 2, 3, 2),
        (3, '2024-01-03 08:00:00', 'Morning Flight', 'International', 'British Airways', 3, 4, 3),
        (4, '2024-01-04 09:00:00', 'Morning Flight', 'International', 'Qantas', 4, 5, 4),
        (5, '2024-01-05 10:00:00', 'Morning Flight', 'Domestic', 'Lufthansa', 5, 6, 5),
        (6, '2024-01-06 11:00:00', 'Morning Flight', 'Domestic', 'Air France', 6, 7, 6),
        (7, '2024-01-07 12:00:00', 'Morning Flight', 'International', 'ANA', 7, 8, 7),
        (8, '2024-01-08 13:00:00', 'Morning Flight', 'International', 'Air China', 8, 9, 8),
        (9, '2024-01-09 14:00:00', 'Morning Flight', 'Domestic', 'Aeroflot', 9, 10, 9),
        (10, '2024-01-10 15:00:00', 'Morning Flight', 'International', 'Vistara', 10, 11, 10);
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;

    BEGIN TRY
        BEGIN TRANSACTION;
        INSERT INTO Flight (FlightID, BoardingTime, FlightDate, Gate, CheckInCounter, FlightNumberID) VALUES 
        (1, '2024-01-01 05:00:00', '2024-01-01', 'A1', 'C1', 1),
        (2, '2024-01-02 06:00:00', '2024-01-02', 'A2', 'C2', 2),
        (3, '2024-01-03 07:00:00', '2024-01-03', 'A3', 'C3', 3),
        (4, '2024-01-04 08:00:00', '2024-01-04', 'A4', 'C4', 4),
        (5, '2024-01-05 09:00:00', '2024-01-05', 'A5', 'C5', 5),
        (6, '2024-01-06 10:00:00', '2024-01-06', 'A6', 'C6', 6),
        (7, '2024-01-07 11:00:00', '2024-01-07', 'A7', 'C7', 7),
        (8, '2024-01-08 12:00:00', '2024-01-08', 'A8', 'C8', 8),
        (9, '2024-01-09 13:00:00', '2024-01-09', 'A9', 'C9', 9),
        (10, '2024-01-10 14:00:00', '2024-01-10', 'A10', 'C10', 10);
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;

    BEGIN TRY
        BEGIN TRANSACTION;
        INSERT INTO Seat (SeatID, Size, Number, Location, PlaneModelID) VALUES 
        (1, 'Standard', 1, 'Window', 1),
        (2, 'Standard', 2, 'Aisle', 2),
        (3, 'Standard', 3, 'Middle', 3),
        (4, 'Standard', 4, 'Window', 4),
        (5, 'Standard', 5, 'Aisle', 5),
        (6, 'Standard', 6, 'Middle', 6),
        (7, 'Standard', 7, 'Window', 7),
        (8, 'Standard', 8, 'Aisle', 8),
        (9, 'Standard', 9, 'Middle', 9),
        (10, 'Standard', 10, 'Window', 10);
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;

    BEGIN TRY
        BEGIN TRANSACTION;
        INSERT INTO AvailableSeat (AvailableSeatID, FlightID, SeatID) VALUES 
        (1, 1, 1),
        (2, 2, 2),
        (3, 3, 3),
        (4, 4, 4),
        (5, 5, 5),
        (6, 6, 6),
        (7, 7, 7),
        (8, 8, 8),
        (9, 9, 9),
        (10, 10, 10);
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;

    BEGIN TRY
        BEGIN TRANSACTION;
        INSERT INTO Coupon (CouponID, DateOfRedemption, Class, Standby, MealCode, TicketID, FlightID) VALUES 
        (1, '2024-01-01', 'Economy', 'Yes', 'VGML', 1, 1),
        (2, '2024-01-02', 'Business', 'No', 'HNML', 2, 2),
        (3, '2024-01-03', 'First', 'No', 'LCML', 3, 3),
        (4, '2024-01-04', 'Economy', 'Yes', 'VGML', 4, 4),
        (5, '2024-01-05', 'Business', 'No', 'HNML', 5, 5),
        (6, '2024-01-06', 'First', 'No', 'LCML', 6, 6),
        (7, '2024-01-07', 'Economy', 'Yes', 'VGML', 7, 7),
        (8, '2024-01-08', 'Business', 'No', 'HNML', 8, 8),
        (9, '2024-01-09', 'First', 'No', 'LCML', 9, 9),
        (10, '2024-01-10', 'Economy', 'Yes', 'VGML', 10, 10);
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;

COMMIT TRANSACTION;



SELECT * 
FROM Flight 
-- WHERE FlightNumberID = 5;




