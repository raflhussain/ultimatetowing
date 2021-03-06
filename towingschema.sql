CREATE TABLE operators (
    operatorid integer primary key autoincrement not null,
    firstname text not null,
    lastname text not null,
    email text not null unique,
    hash text not null,
    cell text,
    member integer not null,
    date_registered text,
    companyid text not null,
        FOREIGN KEY (companyid) REFERENCES companies(companyid)
);

CREATE TABLE owners (
    ownerid integer primary key autoincrement not null,
    firstname text not null,
    lastname text not null,
    email text not null unique,
    hash text not null,
    cell text,
    date_registered text
);

CREATE TABLE companies (
    companyid text primary key not null,
    companyname text not null,
    phone text not null
);

CREATE TABLE trucks (
    truckid integer primary key autoincrement not null,
    make text not null,
    model text not null,
    licenseplate text not null,
    companyid text not null,
    operatorid integer,
        FOREIGN KEY (companyid) REFERENCES companies(companyid),
        FOREIGN KEY (operatorid) REFERENCES operators(operatorid)
);

CREATE TABLE owners_companies (
    ownerid integer not null,
    companyid text not null,
        FOREIGN KEY (ownerid) REFERENCES owners(ownerid),
        FOREIGN KEY (companyid) REFERENCES companies(companyid)
);

CREATE TABLE active_trucks (
    lat text not null,
    lng text not null,
    operatorid integer UNIQUE not null,
        FOREIGN KEY (operatorid) REFERENCES operators(operatorid)
);

CREATE TABLE pounds (
    poundid integer primary key not null,
    address text not null,
    city text not null,
    phone text not null,
    companyid text not null,
	FOREIGN KEY (companyid) REFERENCES companies(companyid)
);

CREATE TABLE customers (
    customerid integer primary key autoincrement not null,
    name text not null,
    address text not null,
    phone text not null,
    insurancecompany text not null,
    insurancepolicy text not null
);

CREATE TABLE incidents (
    incidentid integer primary key autoincrement not null,
    incidentdate text not null,
    pickup text not null,
    dropoff text not null,
    crcused text,
    flattire integer,
    flatbed integer,
    dollies integer,
    boost integer,
    fuel integer,
    winch integer, 
    lockout integer,
    collision integer,
    towed integer,
    keys integer,
    companyid integer not null,
    operatorid integer not null, 
    vehicleid integer not null,
    poundid integer not null,
	FOREIGN KEY (companyid) REFERENCES companies(companyid),
	FOREIGN KEY (operatorid) REFERENCES operators(operatorid),
	FOREIGN KEY (vehicleid) REFERENCES vehicles(vehicleid),
	FOREIGN KEY (poundid) REFERENCES pounds(poundid)
);

CREATE TABLE impounded_vehicles (
    status integer default(1),
    impounded_date text not null,
    vehicleid integer not null,
    poundid integer not null,
    operatorid integer not null,
	FOREIGN KEY (vehicleid) REFERENCES cust_vehicles(vehicleid),
	FOREIGN KEY (poundid) REFERENCES pounds(poundid),
	FOREIGN KEY (operatorid) REFERENCES operators(operatorid)
);
    

CREATE TABLE cust_vehicles (
    vehicleid integer primary key autoincrement not null,
    year text not null,
    make text not null,
    model text not null,
    mileage text not null,
    color text not null,
    licenseplate text not null,
    vin text not null,
    operatorid text,
        FOREIGN KEY (operatorid) REFERENCES operators(operatorid)
);


CREATE TABLE archived_operators (
    date_archived text,
    date_registered text,
    operatorid integer not null,
    firstname text not null,
    lastname text not null,
    email text not null,
    hash text not null,
    cell text,
    companyid text not null,
        FOREIGN KEY (operatorid) REFERENCES operators(operatorid),
        FOREIGN KEY (firstname) REFERENCES operators(firstname),
        FOREIGN KEY (lastname) REFERENCES operators(lastname),
        FOREIGN KEY (email) REFERENCES operators(email),
        FOREIGN KEY (hash) REFERENCES operators(hash),
        FOREIGN KEY (cell) REFERENCES operators(cell),
	FOREIGN KEY (companyid) REFERENCES companies(companyid)
);

CREATE TABLE archived_trucks (
    truckid integer not null,
    make text not null,
    model text not null,
    licenseplate text not null,
    companyid text not null,
    operatorid text,
        FOREIGN KEY (truckid) REFERENCES trucks(truckid),
        FOREIGN KEY (make) REFERENCES trucks(make),
        FOREIGN KEY (model) REFERENCES trucks(model),
        FOREIGN KEY (licenseplate) REFERENCES trucks(licenseplate),
        FOREIGN KEY (companyid) REFERENCES trucks(companyid),
	FOREIGN KEY (operatorid) REFERENCES companies(operatorid)
);

CREATE TABLE archived_pounds (
    poundid integer not null,
    address text not null,
    city text not null,
    phone text not null,
    companyid text not null,
        FOREIGN KEY (companyid) REFERENCES trucks(companyid)
);





--------------------------------------
---------- sqlite3 commands ---------- 
--------------------------------------

// select all operators working under company id 555555555
SELECT firstname, lastname, companies.companyname FROM operators INNER JOIN companies ON companies.companyid = operators.companyid WHERE companies.companyid = 555555555;

// select impounded_vehicles (join with cust_vehicles)
db.execute("""SELECT 
		status, 
		poundid, 
		round(julianday('now') - julianday(impounded_date), 0),
		cust_vehicles.year, 
		cust_vehicles.make, 
		cust_vehicles.model 
	      FROM impounded_vehicles 
	      INNER JOIN cust_vehicles 
	      ON cust_vehicles.vehicleid = impounded_vehicles.vehicleid 
	      WHERE cust_vehicles.operatorid = ?;""", 
	      (operatorid, ))



INSERT INTO operators (
    operatorid,
    firstname,
    lastname,
    email,
    hash,
    member,
    date_registered,
    companyid
    ) VALUES (
    1,
    'homer',
    'simpson',
    'hs@gmail.com',
    'sha2050353846',
    '0',
    'CURRENT_TIMESTAMP',
    '000000000'
    );
