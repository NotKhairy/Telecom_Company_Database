-- 2.1 A --
CREATE DATABASE Telecom_Team_58;

GO
USE Telecom_Team_58;

-- 2.1 B --
GO
CREATE PROCEDURE createAllTables
AS
BEGIN
    CREATE TABLE Customer_profile (
        nationalID INT,
        first_name VARCHAR(50),
        last_name VARCHAR(50),
        email VARCHAR(50),
        address VARCHAR(50),
        date_of_birth DATE,
        PRIMARY KEY(nationalID)
    );

    CREATE TABLE Customer_Account (
        mobileNo CHAR(11),
        pass VARCHAR(50),
        balance DECIMAL(10,1),
        account_type VARCHAR(50),
        start_date DATE,
        status VARCHAR(50),
        point INT,
        nationalID INT,
        PRIMARY KEY(mobileNo),
        CONSTRAINT FK_Customer_Account_NationalID
            FOREIGN KEY(nationalID) REFERENCES Customer_profile(nationalID)
    );

    CREATE TABLE Service_Plan(
        planID INT,
        SMS_offered INT,
        minutes_offered INT,
        data_offered INT,
        name VARCHAR(50),
        price INT,
        description VARCHAR(50),
        PRIMARY KEY(planID)
    );

    CREATE TABLE Subscription(
        mobileNo CHAR(11),
        planID INT,
        subscription_date DATE,
        status VARCHAR(50),
        PRIMARY KEY(mobileNo, planID),
        CONSTRAINT FK_Subscription_MobileNo
            FOREIGN KEY(mobileNo) REFERENCES Customer_Account(mobileNo),
        CONSTRAINT FK_Subscription_PlanID
            FOREIGN KEY(planID) REFERENCES Service_Plan(planID)
    );

    CREATE TABLE Plan_Usage(
        usageID INT,
        start_date DATE,
        end_date DATE,
        data_consumption INT,
        minutes_used INT, 
        SMS_sent INT,
        mobileNo CHAR(11),
        planID INT,
        PRIMARY KEY(usageID),
        CONSTRAINT FK_PlanUsage_MobileNo
            FOREIGN KEY(mobileNo) REFERENCES Customer_Account(mobileNo),
        CONSTRAINT FK_PlanUsage_PlanID
            FOREIGN KEY(planID) REFERENCES Service_Plan(planID)
    );

    CREATE TABLE Payment(
        paymentID INT,
        amount DECIMAL(10,1),
        date_of_payment DATE,
        payment_method VARCHAR(50),
        status VARCHAR(50),
        mobileNo CHAR(11),
        PRIMARY KEY(paymentID),
        CONSTRAINT FK_Payment_MobileNo
            FOREIGN KEY(mobileNo) REFERENCES Customer_Account(mobileNo)
    );

    CREATE TABLE Process_Payment(
        paymentID INT,
        planID INT,
        remaining_balance DECIMAL(10,1), -- DERIVED ATTRIBUTE --
        extra_amount DECIMAL(10,1), -- DERIVED ATTRIBUTE --
        PRIMARY KEY(paymentID),
        CONSTRAINT FK_ProcessPayment_PlanID
            FOREIGN KEY(planID) REFERENCES Service_Plan(planID)
    );

    CREATE TABLE Wallet(
        walletID INT,
        current_balance DECIMAL(10,2),
        currency VARCHAR(50),
        last_modified_date DATE,
        nationalID INT,
        mobileNo CHAR(11),
        PRIMARY KEY(walletID),
        CONSTRAINT FK_Wallet_NationalID
            FOREIGN KEY(nationalID) REFERENCES Customer_profile(nationalID)
    );

    CREATE TABLE Transfer_money(
        walletID1 INT,
        walletID2 INT,
        transfer_id INT,
        amount DECIMAL(10,2),
        transfer_date DATE,
        PRIMARY KEY(walletID1, walletID2, transfer_id),
        CONSTRAINT FK_TransferMoney_WalletID1
            FOREIGN KEY(walletID1) REFERENCES Wallet(walletID),
        CONSTRAINT FK_TransferMoney_WalletID2
            FOREIGN KEY(walletID2) REFERENCES Wallet(walletID)
    );

    CREATE TABLE Benefits(
        benefitID INT,
        description VARCHAR(50),
        validity_date DATE,
        status VARCHAR(50),
        mobileNo CHAR(11),
        PRIMARY KEY(benefitID),
        CONSTRAINT FK_Benefits_MobileNo
            FOREIGN KEY(mobileNo) REFERENCES Customer_Account(mobileNo)
    );

    CREATE TABLE Points_Group (
        pointID INT,
        benefitID INT,
        pointsAmount INT,
        paymentID INT,
        PRIMARY KEY(pointID, benefitID),
        CONSTRAINT FK_PointsGroup_BenefitID
            FOREIGN KEY(benefitID) REFERENCES Benefits(benefitID),
        CONSTRAINT FK_PointsGroup_PaymentID
            FOREIGN KEY(paymentID) REFERENCES Payment(paymentID)
    );

    CREATE TABLE Exclusive_Offer(
        offerID INT,
        benefitID INT,
        internet_offered INT,
        SMS_offered INT,
        minutes_offered INT,
        PRIMARY KEY(offerID, benefitID),
        CONSTRAINT FK_ExclusiveOffer_BenefitID
            FOREIGN KEY(benefitID) REFERENCES Benefits(benefitID)
    );

    CREATE TABLE Cashback(
        cashbackID INT,
        benefitID INT,
        walletID INT,
        amount INT,
        credit_date DATE,
        PRIMARY KEY(cashbackID, benefitID),
        CONSTRAINT FK_Cashback_BenefitID
            FOREIGN KEY(benefitID) REFERENCES Benefits(benefitID),
        CONSTRAINT FK_Cashback_WalletID
            FOREIGN KEY(walletID) REFERENCES Wallet(walletID)
    );

    CREATE TABLE Plan_provides_Benefits(
        benefitID INT,
        planID INT,
        PRIMARY KEY(benefitID, planID),
        CONSTRAINT FK_PlanProvidesBenefits_BenefitID
            FOREIGN KEY(benefitID) REFERENCES Benefits(benefitID),
        CONSTRAINT FK_PlanProvidesBenefits_PlanID
            FOREIGN KEY(planID) REFERENCES Service_Plan(planID)
    );

    CREATE TABLE Shop(
        shopID INT,
        name VARCHAR(50),
        category VARCHAR(50),
        PRIMARY KEY(shopID)
    );

    CREATE TABLE Physical_shop(
        shopID INT,
        address VARCHAR(50),
        working_hours VARCHAR(50),
        PRIMARY KEY(shopID),
        CONSTRAINT FK_PhysicalShop_ShopID
            FOREIGN KEY(shopID) REFERENCES Shop(shopID)
    );

    CREATE TABLE Eshop(
        shopID INT,
        URL VARCHAR(50),
        rating INT,
        PRIMARY KEY(shopID),
        CONSTRAINT FK_Eshop_ShopID
            FOREIGN KEY(shopID) REFERENCES Shop(shopID)
    );

    CREATE TABLE Voucher(
        voucherID INT,
        value INT,
        expiry_date DATE,
        points INT,
        mobileNo CHAR(11),
        shopID INT,
        redeem_date DATE,
        PRIMARY KEY(voucherID),
        CONSTRAINT FK_Voucher_MobileNo
            FOREIGN KEY(mobileNo) REFERENCES Customer_Account(mobileNo),
        CONSTRAINT FK_Voucher_ShopID
            FOREIGN KEY(shopID) REFERENCES Shop(shopID)
    );

    CREATE TABLE Technical_Support_Ticket(
        ticketID INT,
        mobileNo CHAR(11),
        issue_description VARCHAR(50),
        priority_level INT,
        status VARCHAR(50),
        PRIMARY KEY(ticketID, mobileNo),
        CONSTRAINT FK_TechSupportTicket_MobileNo
            FOREIGN KEY(mobileNo) REFERENCES Customer_Account(mobileNo)
    );
END;
GO

EXEC createAllTables;

GO

-- 2.1 C --
CREATE PROCEDURE DropAllTables
AS
	DROP TABLE IF EXISTS Transfer_money, Cashback, Points_Group, 
    Exclusive_Offer, Plan_Provides_Benefits, Benefits, Subscription, 
    Plan_Usage, Process_Payment, Payment, Wallet, Voucher, 
    Technical_Support_Ticket, Customer_Account, Eshop, Physical_Shop,
    Service_Plan, Shop, Customer_profile;
GO

EXEC DropAllTables
GO 

-- 2.1 D (Missing dropping Functions and Views) --
CREATE PROCEDURE dropALLProceduresFunctionsViews
AS
    -- DROP ALL PROCEDURES --
    DROP PROCEDURE IF EXISTS createAllTables, dropAllTables, 
    clearAllTables, Account_Plan, Benefits_Account, Account_Payment_Points,
    Total_Points_Account, Unsubscribed_Plans, Ticket_Account_Customer, 
    Account_Highest_Voucher, Top_Successful_Payments, 
    Initiate_plan_payment, Payment_wallet_cashback, 
    Initiate_balance_payment, Redeem_voucher_points;
GO

EXEC dropALLProceduresFunctionsViews

-- 2.1 E --
GO
CREATE PROCEDURE clearAllTables
AS
    DELETE FROM Transfer_money;
    DELETE FROM Cashback;
    DELETE FROM Points_Group;
    DELETE FROM Exclusive_Offer;
    DELETE FROM Plan_Provides_Benefits;
    DELETE FROM Benefits;
    DELETE FROM Subscription;
    DELETE FROM Plan_Usage;
    DELETE FROM Process_Payment;
    DELETE FROM Payment;
    DELETE FROM Wallet;
    DELETE FROM Voucher;
    DELETE FROM Technical_Support_Ticket;
    DELETE FROM Eshop;
    DELETE FROM Physical_shop;
    DELETE FROM Service_Plan;
    DELETE FROM Shop;
    DELETE FROM Customer_Account;
    DELETE FROM Customer_profile;  
GO

EXEC clearAllTables -- Working but with delete and not truncate--
GO

----------------------------------------------------------------------------------------------------------------------------

-- 2.2 A --
CREATE VIEW allCustomerAccounts AS
SELECT 
    Customer_profile.nationalID,
    Customer_profile.first_name,
    Customer_profile.last_name,
    Customer_profile.email,
    Customer_profile.address,
    Customer_profile.date_of_birth,
    Customer_Account.mobileNo,
    Customer_Account.pass,
    Customer_Account.balance,
    Customer_Account.account_type,
    Customer_Account.start_date,
    Customer_Account.status,
    Customer_Account.point
FROM 
    Customer_profile JOIN  Customer_Account ON 
        Customer_profile.nationalID = Customer_Account.nationalID
WHERE 
    Customer_Account.status = 'active';
GO

SELECT * FROM allCustomerAccounts
GO

-- 2.2 B --
CREATE VIEW allServicePlans AS
SELECT *
FROM Service_Plan
GO

SELECT * FROM allServicePlans
GO

-- 2.2 C --
CREATE VIEW allBenefits AS
SELECT * 
FROM Benefits
WHERE status = 'active'
GO

SELECT * FROM allBenefits
GO

-- 2.2 D --
CREATE VIEW AccountPayments AS
SELECT
Payment.amount,
Payment.date_of_payment,
Payment.mobileNo,
Payment.payment_method,
Payment.paymentID,
Payment.status,
Customer_Account.account_type,
Customer_Account.balance,
Customer_Account.nationalID,
Customer_Account.pass,
Customer_Account.point,
Customer_Account.start_date,
Customer_Account.status AS account_status
FROM Payment JOIN Customer_Account ON (Payment.mobileNo = Customer_Account.mobileNo)
GO

SELECT * FROM AccountPayments
GO

-- 2.2 E --
CREATE VIEW allShops AS
SELECT *
FROM Shop
GO

SELECT * FROM allShops
GO

-- 2.2 F --
CREATE VIEW allResolvedTickets AS
SELECT * 
FROM Technical_Support_Ticket
WHERE Technical_Support_Ticket.status = 'Resolved'
GO

SELECT * FROM allResolvedTickets
GO

-- 2.2 G --
CREATE VIEW CustomerWallet AS
SELECT w.*, cp.first_name, cp.last_name
FROM Wallet AS w JOIN Customer_profile AS cp ON (cp.nationalID = w.nationalID)
GO

SELECT * FROM CustomerWallet
GO

-- 2.2 H --
CREATE VIEW E_shopVouchers AS
SELECT Eshop.*, Voucher.redeem_date, Voucher.value
FROM Eshop JOIN Voucher ON (Eshop.shopID = Voucher.shopID)
WHERE Voucher.redeem_date IS NOT NULL
GO

SELECT * FROM E_shopVouchers
GO

-- 2.2 I --
CREATE VIEW PhysicalStoreVouchers AS
SELECT Physical_shop.*, Voucher.voucherID, Voucher.value
FROM Physical_shop JOIN Voucher ON (Physical_shop.shopID = Voucher.shopID)
WHERE Voucher.redeem_date IS NOT NULL
GO

SELECT * FROM PhysicalStoreVouchers
GO

-- 2.2 J --
CREATE VIEW Num_of_cashback AS
SELECT Wallet.walletID, Count(Cashback.walletID) AS number_of_cashbacks
FROM Wallet JOIN Cashback ON (Wallet.walletID = Cashback.walletID)
GROUP BY Wallet.walletID; 
GO

SELECT * FROM Num_of_cashback
GO

----------------------------------------------------------------------------------------------------------------------------

-- 2.3 A --
CREATE PROCEDURE Account_Plan
AS
    SELECT A.*, P.* FROM Customer_Account A
    INNER JOIN Subscription S ON A.mobileNo = S.mobileNo
    INNER JOIN Service_Plan P ON P.planID = S.planID
GO

EXEC Account_Plan
GO

-- 2.3 B --
CREATE FUNCTION Account_Plan_date
(@Subscription_Date date,
@Plan_id int)
RETURNS TABLE

AS

RETURN
(
SELECT Customer_Account.mobileNo, Subscription.planID, Service_Plan.name
FROM Customer_Account JOIN Subscription ON (Customer_Account.mobileNo = Subscription.mobileNo) JOIN Service_Plan ON (Service_Plan.planID = Subscription.planID)
WHERE Subscription.subscription_date = @Subscription_Date AND Subscription.planID = @Plan_id
)
GO

Select * from dbo.Account_Plan_date('10/10/2024',123)
GO

-- 2.3 C --
CREATE FUNCTION Account_Usage_Plan
(@MobileNo char(11),
@from_date date)
RETURNS TABLE

AS
RETURN
(
SELECT Plan_Usage.planID, Plan_Usage.data_consumption AS 'total data consumed',Plan_Usage.minutes_used AS 'total minutes used', Plan_Usage.SMS_sent AS 'total SMS'
FROM Customer_Account JOIN Plan_Usage ON (Plan_Usage.mobileNo = Customer_Account.mobileNo)
WHERE Customer_Account.mobileNo = @MobileNo AND Plan_Usage.start_date >= @from_date
)
GO

SELECT * FROM dbo.Account_Usage_Plan('01211959101', '10/10/2024')
GO

-- 2.3 D --
CREATE PROCEDURE Benefits_Account
    @MobileNo CHAR(11), 
    @planID INT
AS
    DELETE B
    FROM Benefits B INNER JOIN Subscription S ON B.mobileNo = S.mobileNo
    WHERE B.mobileNo = @MobileNo AND S.planID = @planID;
GO

EXEC Benefits_Account '01011121011', 1
GO

-- 2.3 E --
CREATE FUNCTION Account_SMS_Offers
(@MobileNo char(11))
RETURNS TABLE
AS
RETURN 
(
SELECT Exclusive_Offer.*
FROM Exclusive_Offer JOIN Benefits ON (Exclusive_Offer.benefitID = Benefits.benefitID)
WHERE Benefits.mobileNo = @MobileNo
)
GO

SELECT * FROM dbo.Account_SMS_Offers('01211959101')
GO


-- 2.3 F --
CREATE PROCEDURE Account_Payment_Points
@MobileNo char(11),
@total_transactions int OUTPUT,
@total_points int OUTPUT

AS
BEGIN
    SELECT @total_transactions = COUNT(payment.status)
    FROM Payment 
    WHERE Payment.mobileNo = @MobileNo 
      AND Payment.date_of_payment >= DATEADD(year, -1, CURRENT_TIMESTAMP)
      AND payment.status = 'successful'

    SELECT @total_points = Customer_Account.point
    FROM Customer_Account
    WHERE Customer_Account.mobileNo = @MobileNo
END
GO

DECLARE @total_transactions INT;
DECLARE @total_points INT;
EXEC Account_Payment_Points
@MobileNo = '12345678901',
@total_transactions = @total_transactions OUTPUT,
@total_points = @total_points OUTPUT
SELECT @total_transactions AS TotalTransactions, @total_points AS TotalPoints;
GO


-- 2.3 G --
GO
CREATE FUNCTION Wallet_Cashback_Amount (
    @WalletId INT,
    @planId INT
)
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @CashbackAmount DECIMAL(10, 2);

    SET @CashbackAmount = 0.1 * (
        SELECT P.amount
        FROM Payment P 
        INNER JOIN Process_Payment PP ON P.paymentID = PP.paymentID
        INNER JOIN Plan_provides_Benefits PB ON PB.planID = PP.planID
        INNER JOIN Cashback C ON C.benefitID = PB.benefitID
        WHERE C.walletID = @WalletId AND PP.planID = @planId
    );

    RETURN @CashbackAmount;
END;
GO

SELECT dbo.Wallet_Cashback_Amount(101, 202) AS CashbackAmount;
GO

-- 2.3 H --
CREATE FUNCTION Wallet_Transfer_Amount (
    @Wallet_id INT,
    @start_date DATE,
    @end_date DATE
)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @TransactionAmountAverage DECIMAL(10,2);

    SET @TransactionAmountAverage = (
        SELECT AVG(T.amount)
        FROM Transfer_money T
        WHERE T.walletID1 = @Wallet_id AND T.transfer_date <= @end_date
        AND T.transfer_date >= @start_date
    );

    RETURN @TransactionAmountAverage;
END;
GO

SELECT dbo.Wallet_Transfer_Amount(101, '2024-11-09', '2024-11-23');
GO

-- 2.3 I --
CREATE FUNCTION Wallet_MobileNo (
    @MobileNo CHAR(11)
)
RETURNS BIT
AS
BEGIN
    DECLARE @isLinked BIT;

    SET @isLinked = CASE 
        WHEN EXISTS (
            SELECT *
            FROM Wallet W
            WHERE W.mobileNo = @MobileNo
        )
        THEN 1
        ELSE 0
    END;

    RETURN @isLinked;
END;
GO

SELECT dbo.Wallet_MobileNo('01011121011');

-- 2.3 J --
GO
CREATE PROCEDURE Total_Points_Account
@MobilNo CHAR(11),
@TotalPoints INT OUTPUT

AS
BEGIN
    SELECT @TotalPoints = SUM(P.pointsAmount)
    FROM Points_Group P INNER JOIN Benefits B ON P.benefitID = B.benefitID
    WHERE B.mobileNo = @MobilNo
END
GO

DECLARE @total INT;
EXEC Total_Points_Account '01011121011', @total OUTPUT;
GO

-----------------------------------------------------------------------------------------------------------

-- 2.4 A --
CREATE FUNCTION AccountLoginValidation
(
    @MobileNo CHAR(11),
    @Password VARCHAR(50)
)
RETURNS BIT
AS
BEGIN
    DECLARE @Success BIT;

    IF EXISTS (
        SELECT *
        FROM Customer_Account
        WHERE mobileNo = @MobileNo AND pass = @Password
    )
    BEGIN
        SET @Success = 1;
    END
    ELSE
    BEGIN
        SET @Success = 0;
    END

    RETURN @Success;
END;
GO

SELECT dbo.AccountLoginValidation('01234567890', 'password123') AS LoginSuccess;
GO

-- 2.4 B --
CREATE FUNCTION Consumption
(
    @Plan_name VARCHAR(50),
    @start_date DATE,
    @end_date DATE
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        SUM(PU.data_consumption) AS DataConsumption,
        SUM(PU.minutes_used) AS MinutesUsed,
        SUM(PU.SMS_sent) AS SMSSent
    FROM 
        Plan_Usage PU
    INNER JOIN 
        Service_Plan SP ON PU.planID = SP.planID
    WHERE 
        SP.name = @Plan_name
        AND PU.start_date >= @start_date
        AND PU.end_date <= @end_date
)
GO

SELECT * FROM dbo.Consumption('Basic Plan', '2023-01-01', '2023-12-31');
GO

-- 2.4 C --
CREATE PROCEDURE Unsubscribed_Plans
(
    @MobileNo CHAR(11)
)
AS
BEGIN
    SELECT SP.*
    FROM Service_Plan SP
    WHERE SP.planID NOT IN (
        SELECT S.planID
        FROM Subscription S
        WHERE S.mobileNo = @MobileNo
    );
END;
GO

EXEC Unsubscribed_Plans '01234567890';
GO

-- 2.4 D --
CREATE FUNCTION Usage_Plan_CurrentMonth
(
    @MobileNo CHAR(11)
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        PU.data_consumption AS DataConsumption,
        PU.minutes_used AS MinutesUsed,
        PU.SMS_sent AS SMSSent
    FROM 
        Plan_Usage PU JOIN Subscription S ON (PU.planID = S.planID)
    WHERE 
        PU.mobileNo = @MobileNo
        AND S.status = 'active'
        AND MONTH(PU.start_date) = MONTH(GETDATE())
        AND YEAR(PU.start_date) = YEAR(GETDATE())
)
GO

SELECT * FROM dbo.Usage_Plan_CurrentMonth('01234567890');
GO

-- 2.4 E --
CREATE FUNCTION Cashback_Wallet_Customer (
    @NationalID INT
)
RETURNS TABLE
AS 
RETURN (
    SELECT C.*
    FROM Cashback C
    INNER JOIN Wallet W ON C.walletID = W.walletID
    INNER JOIN Customer_profile P ON P.nationalID = W.nationalID
    WHERE P.nationalID = @NationalID
)
GO

SELECT * FROM dbo.Cashback_Wallet_Customer('1');
GO

-- 2.4 F --
CREATE PROCEDURE Ticket_Account_Customer
    @NationalID INT
AS
BEGIN
    SELECT COUNT(T.ticketID)
    FROM Technical_Support_Ticket T
    WHERE T.status <> 'Resolved'
END;
GO

EXEC Ticket_Account_Customer 1;
GO

-- 2.4 G --
CREATE PROCEDURE Account_Highest_Voucher
    @MobileNo CHAR(11)
AS
BEGIN 
    SELECT MAX(V.value)
    FROM Voucher V
    WHERE V.mobileNo = @MobileNo
END;
GO

EXEC Account_Highest_Voucher '01011121011';
GO

-- 2.4 H --
CREATE FUNCTION Remaining_plan_amount (
    @MobileNo CHAR(11),
    @plan_name VARCHAR(50)
)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @Remaining_amount DECIMAL(10,2);
    SET @Remaining_amount = (
        SELECT PP.remaining_balance
        FROM Process_Payment PP
        INNER JOIN Service_Plan S ON PP.planID = S.planID
        INNER JOIN Payment P ON PP.paymentID = P.paymentID
        WHERE P.mobileNo = @MobileNo AND S.name = @plan_name
    )
    RETURN @Remaining_amount;
END;
GO

SELECT * FROM dbo.Remaining_plan_amount('01011121011', 'plan'); -- NOT WORKING
GO

-- 2.4 I --
CREATE FUNCTION Extra_plan_amount (
    @MobileNo CHAR(11),
    @plan_name VARCHAR(50)
)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @Extra_amount DECIMAL(10,2)
    SET @Extra_amount = (
        SELECT PP.extra_amount
        FROM Process_Payment PP
        INNER JOIN Service_Plan S ON PP.planID = S.planID
        INNER JOIN Payment P ON PP.paymentID = P.paymentID
        WHERE P.mobileNo = @MobileNo AND S.name = @plan_name
    )
    RETURN @Extra_amount
END;
GO

SELECT * FROM dbo.Extra_plan_amount('01011121011', 'plan'); -- NOT WORKING
GO

-- 2.4 J --
CREATE PROCEDURE Top_Successful_Payments
    @MobileNo CHAR(11)
AS
BEGIN
    SELECT TOP 10 P.amount
    FROM Payment P
    WHERE P.status = 'Successful' AND P.mobileNo = @MobileNo
    ORDER BY P.amount DESC;
END;
GO

EXEC Top_Successful_Payments '01011121011';
GO

-- 2.4 K --
CREATE FUNCTION Subscribed_plans_5_Months (
    @MobileNo CHAR(11)
)
RETURNS TABLE
AS 
RETURN(
    SELECT P.*
    FROM Service_Plan P INNER JOIN Subscription S ON P.planID = S.planID
    WHERE S.subscription_date >= DATEADD(MONTH, -5, GETDATE())
)
GO

SELECT * FROM dbo.Subscribed_plans_5_Months('01011121011');
GO

-- 2.4 L --
CREATE PROCEDURE Initiate_plan_payment
    @MobileNo CHAR(11),
    @amount DECIMAL(10,1),
    @payment_method VARCHAR(50),
    @plan_id INT
AS
BEGIN
    DECLARE @current_balance DECIMAL(10,1);

    SELECT @current_balance = balance
    FROM Customer_Account
    WHERE mobileNo = @MobileNo;

    IF @current_balance IS NOT NULL
    BEGIN
        IF @current_balance >= @amount
        BEGIN
            UPDATE Customer_Account
            SET balance = balance - @amount
            WHERE mobileNo = @MobileNo;

            INSERT INTO Payment (amount, date_of_payment, payment_method, status, mobileNo)
            VALUES (@amount, GETDATE(), @payment_method, 'Successful', @MobileNo);
        END
        ELSE
        BEGIN
            INSERT INTO Payment (amount, date_of_payment, payment_method, status, mobileNo)
            VALUES (@amount, GETDATE(), @payment_method, 'Rejected', @MobileNo);
        END
    END
END;
GO

EXEC Initiate_plan_payment '01011121011',50,'Cash', 1;
GO


-- 2.4 M --
CREATE PROCEDURE Payment_wallet_cashback
    @MobileNo CHAR(11),
    @payment_id INT,
    @benefit_id INT
AS
BEGIN
    DECLARE @cashback_amount DECIMAL(10, 2);
    DECLARE @wallet_id INT;

    SELECT @cashback_amount = 0.1 * P.amount
    FROM Payment P
    WHERE P.paymentID = @payment_id;

    SELECT @wallet_id = W.walletID
    FROM Wallet W
    WHERE W.mobileNo = @MobileNo;

    UPDATE Wallet
    SET current_balance = current_balance + @cashback_amount
    WHERE walletID = @wallet_id;

    INSERT INTO Cashback (benefitID, walletID, amount, credit_date)
    VALUES (@benefit_id, @wallet_id, @cashback_amount, GETDATE());
END;
GO

EXEC Payment_wallet_cashback '01234567890', 1, 1; --Not working due to primary keys declarations
GO


-- 2.4 N --
CREATE PROCEDURE Initiate_balance_payment
    @MobileNo CHAR(11),
    @amount DECIMAL(10,1),
    @payment_method VARCHAR(50)
AS
BEGIN
    INSERT INTO Payment (amount, date_of_payment, payment_method, status, mobileNo)
    VALUES (@amount, GETDATE(), @payment_method, 'accepted', @MobileNo);

    UPDATE Wallet
    SET current_balance = current_balance + @amount,
        last_modified_date = GETDATE()
    WHERE mobileNo = @MobileNo;
END;
GO

EXEC Initiate_balance_payment '01234567890', 100.0, 'Credit Card';
GO

-- 2.4 O --
CREATE PROCEDURE Redeem_voucher_points
    @MobileNo CHAR(11),
    @voucher_id INT
AS
BEGIN
        DECLARE @voucher_points INT;
        SELECT @voucher_points = points
        FROM Voucher
        WHERE voucherID = @voucher_id;

        UPDATE Voucher
        SET redeem_date = GETDATE()
        WHERE voucherID = @voucher_id;

        UPDATE Customer_Account
        SET point = point - @voucher_points
        WHERE mobileNo = @MobileNo;

END;
GO

EXEC Redeem_voucher_points '01234567890', 12321;
GO

