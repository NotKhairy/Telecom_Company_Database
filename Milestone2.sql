--2.1 A--
CREATE DATABASE Telecom_Team_58;

GO
USE Telecom_Team_58;

--2.1 B--
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

-- 2.1 D (Missing dropping Functions and Views)--
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

-- 2.1 E--
GO

-- 2.1 E--
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

--2.2 A--
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

--2.2 B--
CREATE VIEW allServicePlans AS
SELECT *
FROM Service_Plan
GO

SELECT * FROM allServicePlans
GO

--2.2 C--
CREATE VIEW allBenefits AS
SELECT * 
FROM Benefits
WHERE status = 'active'
GO

SELECT * FROM allBenefits
GO

--2.2 D--
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

--2.2 E--
CREATE VIEW allShops AS
SELECT *
FROM Shop
GO

SELECT * FROM allShops
GO

--2.2 F--
CREATE VIEW allResolvedTickets AS
SELECT * 
FROM Technical_Support_Ticket
WHERE Technical_Support_Ticket.status = 'Resolved'
GO

SELECT * FROM allResolvedTickets
GO

--2.2 G--
CREATE VIEW CustomerWallet AS
SELECT w.*, cp.first_name, cp.last_name
FROM Wallet AS w JOIN Customer_profile AS cp ON (cp.nationalID = w.nationalID)
GO

SELECT * FROM CustomerWallet
GO

--2.2 H--
CREATE VIEW E_shopVouchers AS
SELECT Eshop.*, Voucher.redeem_date, Voucher.value
FROM Eshop JOIN Voucher ON (Eshop.shopID = Voucher.shopID)
WHERE Voucher.redeem_date IS NOT NULL
GO

SELECT * FROM E_shopVouchers
GO

--2.2 I--
CREATE VIEW PhysicalStoreVouchers AS
SELECT Physical_shop.*, Voucher.voucherID, Voucher.value
FROM Physical_shop JOIN Voucher ON (Physical_shop.shopID = Voucher.shopID)
WHERE Voucher.redeem_date IS NOT NULL
GO

SELECT * FROM PhysicalStoreVouchers
GO

--2.2 J--
CREATE VIEW Num_of_cashback AS
SELECT Wallet.walletID, Count(Cashback.walletID) AS number_of_cashbacks
FROM Wallet JOIN Cashback ON (Wallet.walletID = Cashback.walletID)
GROUP BY Wallet.walletID; 
GO

SELECT * FROM Num_of_cashback
GO

----------------------------------------------------------------------------------------------------------------------------

--2.3 A--
CREATE PROCEDURE Account_Plan
AS
    SELECT A.*, P.* FROM Customer_Account A
    INNER JOIN Subscription S ON A.mobileNo = S.mobileNo
    INNER JOIN Service_Plan P ON P.planID = S.planID
GO

EXEC Account_Plan
GO

--2.3 B--
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

--2.3 C--
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

--2.3 D--
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

