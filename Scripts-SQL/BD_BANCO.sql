DROP DATABASE TPIntegradorLaboratorio4;

CREATE DATABASE TPIntegradorLaboratorio4;

USE TPIntegradorLaboratorio4;

CREATE TABLE USUARIOS (
    IDUsuario INT PRIMARY KEY AUTO_INCREMENT,
    Usuario VARCHAR(25) NOT NULL,
    Contrasenia VARCHAR(25) NOT NULL,
    TipoUsuario INT NOT NULL
);


CREATE TABLE PROVINCIAS (
    IDProvincia INT PRIMARY KEY AUTO_INCREMENT,
    Nombre VARCHAR(50) NOT NULL
);


CREATE TABLE LOCALIDADES (
    IDLocalidad INT PRIMARY KEY AUTO_INCREMENT,
    Nombre VARCHAR(50) NOT NULL
);


CREATE TABLE DIRECCIONES (
    IDDireccion INT PRIMARY KEY AUTO_INCREMENT,
    IDProvincia INT,
    IDLocalidad INT,
    CodigoPostal VARCHAR(15) NOT NULL,
    Calle VARCHAR(30) NOT NULL,
    Numero VARCHAR(30) NOT NULL,
    FOREIGN KEY (IDLocalidad) REFERENCES LOCALIDADES (IDLocalidad),
    FOREIGN KEY (IDProvincia) REFERENCES PROVINCIAS (IDProvincia)
);


CREATE TABLE NACIONALIDADES (
	IDNacionalidad INT PRIMARY KEY AUTO_INCREMENT,
    Nacionalidad VARCHAR(40) UNIQUE NOT NULL
);

CREATE TABLE CLIENTES (
    IDCliente INT PRIMARY KEY AUTO_INCREMENT,
    DNI VARCHAR(13) UNIQUE NOT NULL,
    CUIL VARCHAR(13) UNIQUE NOT NULL,
    Nombre VARCHAR(50) NOT NULL,
    Apellido VARCHAR(50) NOT NULL,
    Sexo VARCHAR(20) NOT NULL,
    IDNacionalidad INT NOT NULL,
    Telefono VARCHAR(30) NOT NULL,
    FechaNacimiento DATE NOT NULL,
    IDDireccion INT,
    Email VARCHAR(45) NOT NULL,
    Estado BIT DEFAULT 1 NOT NULL,
    IDUsuario INT,
    FOREIGN KEY (IDUsuario) REFERENCES USUARIOS(IDUsuario),
    FOREIGN KEY (IDNacionalidad) REFERENCES NACIONALIDADES(IDNacionalidad)
);

CREATE TABLE TIPO_PRESTAMOS (
    IDTipoPrestamo INT PRIMARY KEY AUTO_INCREMENT,
	Tipo VARCHAR(50) NOT NULL,
    TNA DECIMAL NOT NULL,
	CONSTRAINT chk_Tipo CHECK (Tipo NOT REGEXP '[^a-zA-Z]')
);

CREATE TABLE TIPO_CUENTAS (
    IDTipoCuenta INT PRIMARY KEY AUTO_INCREMENT,
    Tipo VARCHAR(50) NOT NULL
);

INSERT INTO TIPO_CUENTAS (Tipo) 
VALUES 
('Caja de Ahorro'),
('Cuenta corriente');

CREATE TABLE CUENTAS (
    IDCuenta INT PRIMARY KEY AUTO_INCREMENT,
    IDCliente INT,
    FechaCreacion DATE NOT NULL,
    NumeroCuenta INT NOT NULL,
    CBU VARCHAR(50) NOT NULL,
    Saldo DECIMAL(18,2) NOT NULL,
    IDTipoCuenta INT NOT NULL,
    ESTADO BOOLEAN NOT NULL DEFAULT TRUE,
    
    CONSTRAINT fk_Cuentas_Tipo_Cuentas FOREIGN KEY (IDTipoCuenta) REFERENCES TIPO_CUENTAS(IDTipoCuenta),
    CONSTRAINT fk_Cuentas_Clientes FOREIGN KEY (IDCliente) REFERENCES CLIENTES(IDCliente),
    CONSTRAINT chk_CBU CHECK (CBU REGEXP '^[0-9]+$'),
    CONSTRAINT chk_Saldo CHECK (Saldo REGEXP '^[0-9]+(\\.[0-9]{1,6})?$')
);

CREATE TABLE PRESTAMOS (
    IDPrestamo INT PRIMARY KEY AUTO_INCREMENT,
    IDTipoPrestamo INT NOT NULL,
    IDCuenta INT NOT NULL,
    MontoPedido DECIMAL(10,2) NOT NULL,
    ImporteAPagar DECIMAL(10,2) NOT NULL,
    Cuotas INT NOT NULL,
    Fecha DATE NOT NULL,
    Estado TINYINT NOT NULL DEFAULT 0, -- 0 pendiente, 1 aprobado, 2 rechazado
	CONSTRAINT fk_PrestamoId FOREIGN KEY (IDTipoPrestamo) REFERENCES TIPO_PRESTAMOS(IDTipoPrestamo),
    CONSTRAINT fk_CuentaId FOREIGN KEY (IDCuenta) REFERENCES CUENTAS(IDCuenta),
    CONSTRAINT chk_Monto CHECK (MontoPedido REGEXP '^[0-9]+(\\.[0-9]{1,2})?$'),
    CONSTRAINT chk_ImporteAPagar CHECK (ImporteAPagar REGEXP '^[0-9]+(\\.[0-9]{1,2})?$')
);

CREATE TABLE PLAZOS (
    IDPlazo INT PRIMARY KEY AUTO_INCREMENT,
    IDPrestamo INT,
    FechaDeVencimiento DATE NOT NULL,
    FechaDePago DATE NULL,
    NroCuota INT NOT NULL,
    ImporteAPagarCuotas DECIMAL(10,2) NOT NULL,
    Estado BIT NOT NULL,
    CONSTRAINT fk_Plazos_Prestamos FOREIGN KEY (IDPrestamo) REFERENCES PRESTAMOS(IDPrestamo),
    CONSTRAINT chk_Mes CHECK (MesQuePaga NOT REGEXP '[^a-zA-Z]'),
    CONSTRAINT chk_NroCuota CHECK (NroCuota REGEXP '^[0-9]+$')
);

CREATE TABLE TIPO_MOVIMIENTOS (
    IDTipoMovimiento INT PRIMARY KEY AUTO_INCREMENT,
    Nombre VARCHAR(100) NOT NULL
);

INSERT INTO TIPO_MOVIMIENTOS (Nombre) 
VALUES ('Alta de cuenta'),
('Alta de préstamo'),
('Pago de préstamo'),
('Transferencia'),
('Administrativo');

CREATE TABLE MOVIMIENTOS (
    IDMovimiento INT PRIMARY KEY AUTO_INCREMENT,
    Fecha DATE NOT NULL,
    DetalleOrigen VARCHAR(100) NULL, 
    DetalleDestino VARCHAR(100) NOT NULL,
    Importe DECIMAL(18,2) NOT NULL,
    IDCuentaEmisor INT,
    IDCuentaReceptor INT, 
    IDTipoMovimiento INT NOT NULL,
    CONSTRAINT fk_Movimientos_Tipo_Movimientos FOREIGN KEY (IDTipoMovimiento) REFERENCES TIPO_MOVIMIENTOS(IDTipoMovimiento),
    CONSTRAINT chk_Importe CHECK (Importe REGEXP '^[0-9]+(\\.[0-9]{1,2})?$')
);

-- Trigger que genera cbu + numero de cuenta y registra la fecha actual del sistema al insertar una cuenta

-- Elimina el trigger si existe
DROP TRIGGER IF EXISTS before_insert_cuenta;
--

DELIMITER //

CREATE TRIGGER before_insert_cuenta
BEFORE INSERT ON CUENTAS
FOR EACH ROW
BEGIN

    DECLARE CBU_GENERADO VARCHAR(50);  
    DECLARE CBU_EXISTE INT;

    IF NEW.NumeroCuenta IS NULL THEN
        SET NEW.NumeroCuenta = (SELECT IFNULL(MAX(NumeroCuenta), 10000) + 1 FROM CUENTAS);
    END IF;

    IF NEW.CBU IS NULL THEN
        REPEAT
            SET CBU_GENERADO = CONCAT('4540900', LPAD(FLOOR(RAND() * 10000000), 7, '0'));  

            SET CBU_EXISTE = (SELECT COUNT(*) FROM CUENTAS WHERE CBU = CBU_GENERADO);
        UNTIL CBU_EXISTE = 0 END REPEAT;

        SET NEW.CBU = CBU_GENERADO;
    END IF;

    SET NEW.FechaCreacion = NOW();
END;
//

DELIMITER ;


-- Procedimiento para el listado de clientes en general

DELIMITER $$

CREATE PROCEDURE SP_ListarClientesPaginado(
    IN p_limit INT,
    IN p_offset INT
)
BEGIN
    SELECT
		c.IDCliente AS idCliente,
        c.DNI AS dni,
        c.Nombre AS nombre,
        c.Apellido AS apellido,
        c.Estado AS estado,
        COUNT(cu.IDCuenta) AS cantCuentas
    FROM 
        clientes c
    LEFT JOIN 
        cuentas cu ON cu.IDCliente = c.IDCliente
	INNER JOIN
		usuarios u ON u.IDUsuario = c.IDUsuario
	WHERE u.TipoUsuario = 2
    GROUP BY 
        c.DNI, c.Nombre, c.Apellido, c.Estado
    LIMIT p_limit OFFSET p_offset;
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE SP_EditarCliente(
    IN p_idCliente INT, 
    IN p_dni VARCHAR(13),
    IN p_cuil VARCHAR(13),
    IN p_nombre VARCHAR(50),
    IN p_apellido VARCHAR(50),
    IN p_sexo VARCHAR(20),
    IN p_telefono VARCHAR(30),
    IN p_idNacionalidad INT,
    IN p_fechaNacimiento DATE,
    IN p_email VARCHAR(45),
    IN p_codigoPostal VARCHAR(15),
    IN p_calle VARCHAR(30),
    IN p_numero VARCHAR(30),
    IN p_idLocalidad INT,
    IN p_idProvincia INT
)
BEGIN
    -- Declarar variable para manejo de transacción
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    -- Iniciar transacción
    START TRANSACTION;

    -- Verificar si la dirección ha cambiado
    IF p_codigoPostal IS NOT NULL OR p_calle IS NOT NULL OR p_numero IS NOT NULL OR p_idLocalidad IS NOT NULL OR p_idProvincia IS NOT NULL THEN
        -- Actualización de la tabla DIRECCIONES
        UPDATE DIRECCIONES
        SET IDProvincia = p_idProvincia,
            IDLocalidad = p_idLocalidad,
            CodigoPostal = p_codigoPostal,
            Calle = p_calle,
            Numero = p_numero
        WHERE IDDireccion = (SELECT IDDireccion FROM CLIENTES WHERE IDCliente = p_idCliente);
    END IF;

    -- Actualización de la tabla CLIENTES
    UPDATE CLIENTES
    SET DNI = p_dni,
        CUIL = p_cuil,
        Nombre = p_nombre,
        Apellido = p_apellido,
        Sexo = p_sexo,
        IDNacionalidad = p_idNacionalidad,
        Telefono = p_telefono,
        FechaNacimiento = p_fechaNacimiento,
        Email = p_email
    WHERE IDCliente = p_idCliente;

    -- Confirmar transacción
    COMMIT;
END $$

DELIMITER ;



-- Procedimiento para obtener detalles del cliente
DELIMITER $$

CREATE PROCEDURE SP_DetalleCliente(
    IN p_IDCliente INT
)
BEGIN
    SELECT 
        u.Usuario AS usuario,
        c.IDCliente AS idCliente,
        c.Nombre AS nombre,
        c.Apellido AS apellido,
        c.Email AS email,
        c.DNI AS dni,
        c.CUIL AS cuil,
        c.ESTADO AS estado,
        c.FechaNacimiento AS fechaNacimiento,
        c.Sexo AS sexo,
        c.Telefono AS telefono,
        c.IDNacionalidad AS idNacionalidad,
        d.Calle AS calle,
        d.Numero AS numero,
        d.CodigoPostal AS codigoPostal,
        l.IDLocalidad AS idLocalidad,
        p.IDProvincia AS idProvincia
    FROM 
        clientes c
    INNER JOIN 
        usuarios u ON u.IDUsuario = c.IDUsuario
    LEFT JOIN 
        direcciones d ON d.IDDireccion = c.IDDireccion
    LEFT JOIN 
        localidades l ON l.IDLocalidad = d.IDLocalidad
    LEFT JOIN 
        provincias p ON p.IDProvincia = d.IDProvincia
    WHERE 
        c.IDCliente = p_IDCliente;
END$$

DELIMITER ;

-- Procedimiento para el alta de un cliente
DELIMITER $$
CREATE PROCEDURE SP_AgregarCliente(
    IN p_nombreUsuario VARCHAR(25),
    IN p_password VARCHAR(25),
    IN p_dni INT,
    IN p_cuil VARCHAR(50),
    IN p_nombre VARCHAR(50),
    IN p_apellido VARCHAR(50),
    IN p_sexo VARCHAR(20),
    IN p_telefono VARCHAR(30),
    IN p_idNacionalidad INT,
    IN p_fechaNacimiento DATE,
    IN p_email VARCHAR(45),
    IN p_codigoPostal VARCHAR(15),
    IN p_calle VARCHAR(30),
    IN p_numero INT,
    IN p_idLocalidad INT,
    IN p_idProvincia INT
)
BEGIN
    -- Declarar variable para manejo de transacción
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    -- Iniciar transacción
    START TRANSACTION;

    -- Inserción en la tabla USUARIOS
    INSERT INTO USUARIOS(Usuario, Contrasenia, TipoUsuario) 
    VALUES (p_nombreUsuario, p_password, 2);
    
    -- Obtener el último ID de usuario
    SET @last_usuario_id = LAST_INSERT_ID();

    -- Inserción en la tabla DIRECCIONES
    INSERT INTO DIRECCIONES(IDProvincia, IDLocalidad, CodigoPostal, Calle, Numero)
    VALUES (p_idProvincia, p_idLocalidad, p_codigoPostal, p_calle, p_numero);
    
    -- Obtener el último ID de dirección
    SET @last_direccion_id = LAST_INSERT_ID();

    -- Inserción en la tabla CLIENTES
    INSERT INTO CLIENTES(DNI, CUIL, Nombre, Apellido, Sexo, IDNacionalidad, Telefono, FechaNacimiento, IDDireccion, Email, IDUsuario)
    VALUES (p_dni, p_cuil, p_nombre, p_apellido, p_sexo, p_idNacionalidad, p_telefono, p_fechaNacimiento, @last_direccion_id, p_email, @last_usuario_id);

    -- Confirmar transacción
    COMMIT;
END $$
DELIMITER ;


-- Procedimiento para obtener credenciales del cliente
DELIMITER $$
CREATE PROCEDURE SP_ClientePorIdUsuario(
    IN p_IDUsuario INT
)
BEGIN
	SELECT
		c.IDCliente AS idCliente,
		c.DNI AS dni,
		c.CUIL AS cuil,
		c.Nombre AS nombre,
		c.Apellido AS apellido,
		c.Sexo AS sexo,
		c.IDNacionalidad AS idNacionalidad,
		c.Telefono AS telefono,
		c.FechaNacimiento AS fechaNacimiento,
		c.IDDireccion AS idDireccion,
		c.Email AS email,
		c.Estado AS estado,
        c.IDDireccion AS idDireccion,
        u.Usuario as nombreUsuario,
        d.Calle AS calle,
        d.Numero AS numero,
        d.CodigoPostal AS codigoPostal,
        l.IDLocalidad AS idLocalidad,
        p.IDProvincia AS idProvincia
	FROM Clientes c
    INNER JOIN 
        Usuarios u ON u.IDUsuario = c.IDUsuario
	LEFT JOIN
		Nacionalidades n ON n.IDNacionalidad = c.IDNacionalidad
    LEFT JOIN 
        Direcciones d ON d.IDDireccion = c.IDDireccion
    LEFT JOIN 
        Localidades l ON l.IDLocalidad = d.IDLocalidad
    LEFT JOIN 
        Provincias p ON p.IDProvincia = d.IDProvincia
    WHERE c.IDUsuario = p_IDUsuario;
END$$
DELIMITER ;


-- Procedimiento para realizar una transferencia. (Con transacción)
DELIMITER $$

CREATE PROCEDURE SP_RealizarTransferencia(
    IN p_cbuOrigen VARCHAR(50), 
    IN p_cbuDestino VARCHAR(50), 
    IN p_monto DECIMAL(18,2)
)
BEGIN
    DECLARE v_saldoOrigen DECIMAL(18,2);
    DECLARE v_estadoOrigen BOOLEAN;
    DECLARE v_estadoDestino BOOLEAN;
    DECLARE v_idCuentaOrigen INT;
    DECLARE v_idCuentaDestino INT;
    DECLARE v_idClienteOrigen INT;
    DECLARE v_idClienteDestino INT;
    DECLARE v_nombreOrigen VARCHAR(50);
    DECLARE v_apellidoOrigen VARCHAR(50);
    DECLARE v_nombreDestino VARCHAR(50);
    DECLARE v_apellidoDestino VARCHAR(50);
    DECLARE v_detalleOrigen VARCHAR(255);
    DECLARE v_detalleDestino VARCHAR(255);

    START TRANSACTION;
	
    -- Obtiene detalles de la cuenta origen
    SELECT IDCuenta, Saldo, ESTADO, IDCliente
    INTO v_idCuentaOrigen, v_saldoOrigen, v_estadoOrigen, v_idClienteOrigen
    FROM CUENTAS
    WHERE CBU = p_cbuOrigen;

    IF v_idCuentaOrigen IS NULL THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La cuenta origen no existe.';
    END IF;

    IF v_estadoOrigen = FALSE THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La cuenta origen está inactiva.';
    END IF;

    -- Obtiene detalles del cliente de la cuenta origen
    SELECT Nombre, Apellido
    INTO v_nombreOrigen, v_apellidoOrigen
    FROM CLIENTES
    WHERE IDCliente = v_idClienteOrigen;

    -- Obtiene detalles de la cuenta destino
    SELECT IDCuenta, ESTADO, IDCliente 
    INTO v_idCuentaDestino, v_estadoDestino, v_idClienteDestino
    FROM CUENTAS
    WHERE CBU = p_cbuDestino;

    IF v_idCuentaDestino IS NULL THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La cuenta destino no existe.';
    END IF;

    IF v_estadoDestino = FALSE THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La cuenta destino está inactiva.';
    END IF;
	
    -- Obtiene detalles del cliente de la cuenta destino
    SELECT Nombre, Apellido
    INTO v_nombreDestino, v_apellidoDestino
    FROM CLIENTES
    WHERE IDCliente = v_idClienteDestino;

    -- Verifica si el saldo es suficiente
    IF v_saldoOrigen < p_monto THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Saldo insuficiente en la cuenta origen.';
    END IF;
    
    -- Si el IDCliente en origen y destino son iguales, es un traspaso
    IF v_idClienteOrigen = v_idClienteDestino THEN
        SET v_detalleOrigen = NULL;  -- Detalle origen es NULL
        SET v_detalleDestino = 'Traspaso de dinero entre cuentas';
    ELSE
        -- Si son diferentes, es una transferencia
        SET v_detalleOrigen = CONCAT('Transferencia a ', v_nombreDestino, ' ', v_apellidoDestino);
        SET v_detalleDestino = CONCAT('Transferencia recibida de ', v_nombreOrigen, ' ', v_apellidoOrigen);
    END IF;
	
    -- Actualizo los saldos de las cuentas
    UPDATE CUENTAS
    SET Saldo = Saldo - p_monto
    WHERE IDCuenta = v_idCuentaOrigen;

    UPDATE CUENTAS
    SET Saldo = Saldo + p_monto
    WHERE IDCuenta = v_idCuentaDestino;
    
    -- Insert del movimiento
    INSERT INTO MOVIMIENTOS (Fecha, DetalleOrigen, DetalleDestino, Importe, IDCuentaEmisor, IDCuentaReceptor, IDTipoMovimiento)
    VALUES (CURDATE(), v_detalleOrigen, v_detalleDestino, p_monto, v_idCuentaOrigen, v_idCuentaDestino, 4);

    COMMIT;

END $$

DELIMITER ;

-- Procedure para solicitar un préstamo
DELIMITER $$

CREATE PROCEDURE InsertarPrestamo (
    IN idTipoPrestamo INT,
    IN idCuenta INT,
    IN monto DECIMAL(10,2),
    IN cuotas INT,
    OUT estado BOOLEAN
)
BEGIN
    DECLARE tasaAnual DECIMAL(10,2);
    DECLARE montoAPagar DECIMAL(10,2);

    SELECT TNA INTO tasaAnual
    FROM TIPO_PRESTAMOS
    WHERE IDTipoPrestamo = idTipoPrestamo
    LIMIT 1;

    SET montoAPagar = monto * (1 + tasaAnual / 100);
	
    INSERT INTO PRESTAMOS (IDTipoPrestamo, IDCuenta, MontoPedido, ImporteAPagar, Cuotas, Fecha)
    VALUES (idTipoPrestamo, idCuenta, monto, montoAPagar, cuotas, CURDATE()); 
	
    SET estado = ROW_COUNT() = 1;
END $$

DELIMITER ;

-- Procedure para aprobar préstamo y generar las cuotas del mismo
DELIMITER //

CREATE PROCEDURE SP_AprobarPrestamo (IN p_IDPrestamo INT)
BEGIN
    DECLARE v_MontoPedido DECIMAL(10,2);
    DECLARE v_Cuotas INT;
    DECLARE v_ImporteCuota DECIMAL(10,2);
    DECLARE v_IDCuenta INT;
    DECLARE v_ImporteAPagar DECIMAL(10,2);
    DECLARE v_FechaAprobacion DATE DEFAULT CURDATE();
    DECLARE v_TipoPrestamo VARCHAR(50);

    UPDATE PRESTAMOS
    SET Estado = 1
    WHERE IDPrestamo = p_IDPrestamo;

    SELECT MontoPedido, Cuotas, IDCuenta, ImporteAPagar, TP.Tipo AS TipoPrestamo
    INTO v_MontoPedido, v_Cuotas, v_IDCuenta, v_ImporteAPagar, v_TipoPrestamo
    FROM PRESTAMOS P
    JOIN TIPO_PRESTAMOS TP ON P.IDTipoPrestamo = TP.IDTipoPrestamo
    WHERE IDPrestamo = p_IDPrestamo;

    SET v_ImporteCuota = v_ImporteAPagar / v_Cuotas;

    -- Genera las cuotas en la tabla PLAZOS
    BEGIN
        DECLARE i INT DEFAULT 1;
        WHILE i <= v_Cuotas DO
            INSERT INTO PLAZOS (IDPrestamo, FechaDeVencimiento, FechaDePago, NroCuota, ImporteAPagarCuotas, Estado)
            VALUES (
                p_IDPrestamo,
                DATE_ADD(v_FechaAprobacion, INTERVAL i MONTH),
                NULL,
                i,
                v_ImporteCuota,
                0
            );
            SET i = i + 1;
        END WHILE;
    END;

    INSERT INTO MOVIMIENTOS (Fecha, DetalleOrigen, DetalleDestino, Importe, IDCuentaEmisor, IDCuentaReceptor, IDTipoMovimiento)
    VALUES (
        v_FechaAprobacion,
        'Alta de préstamo', 
        CONCAT('Préstamo ',v_TipoPrestamo), 
        v_MontoPedido,
        v_IDCuenta,
        v_IDCuenta,
        2 
    );
END //

DELIMITER ;


-- Procedure que devuelve listado paginado con los préstamos activos
DELIMITER //

CREATE PROCEDURE SP_ListarPrestamosActivos(
    IN limite INT, 
    IN offset INT
)
BEGIN
    SELECT 
        p.IDPrestamo AS idPrestamo,
        c.Nombre AS nombre,
        c.Apellido AS apellido,
        p.MontoPedido AS montoPedido,
        p.ImporteAPagar AS importeAPagar,
        tp.Tipo AS tipoPrestamo,
        (SELECT COUNT(*) 
         FROM plazos 
         WHERE plazos.IDPrestamo = p.IDPrestamo) AS cuotasTotales,
        (SELECT COUNT(*) 
         FROM plazos 
         WHERE plazos.IDPrestamo = p.IDPrestamo AND plazos.Estado = 1) AS cuotasAbonadas,
        MAX(m.Fecha) AS fechaAprobacion, -- Asegura una única fecha
        p.Estado AS estado
    FROM prestamos p
    INNER JOIN tipo_prestamos tp ON tp.IDTipoPrestamo = p.IDTipoPrestamo
    INNER JOIN cuentas cu ON cu.IDCuenta = p.IDCuenta
    INNER JOIN clientes c ON c.IDCliente = cu.IDCliente
    INNER JOIN movimientos m ON m.IDCuentaEmisor = cu.IDCuenta
    WHERE p.Estado = 1
    GROUP BY p.IDPrestamo, c.Nombre, c.Apellido, p.MontoPedido, p.ImporteAPagar, tp.Tipo, p.Estado
    LIMIT limite OFFSET offset;
END //

DELIMITER ;


-- Inserts para la tabla NACIONALIDADES
INSERT INTO NACIONALIDADES (Nacionalidad) 
VALUES
('Argentina'),
('Boliviana'),
('Brasileña'),
('Chilena'),
('Paraguaya'),
('Peruana'),
('Venezolana'),
('Uruguaya');

-- Inserts para la tabla PROVINCIAS
INSERT INTO PROVINCIAS (Nombre) 
VALUES 
('Buenos Aires'),
('Catamarca'),
('Chaco'),
('Chubut'),
('Córdoba'),
('Corrientes'),
('Entre Ríos'),
('Formosa'),
('Jujuy'),
('La Pampa'),
('La Rioja'),
('Mendoza'),
('Misiones'),
('Neuquén'),
('Río Negro'),
('Salta'),
('San Juan'),
('San Luis'),
('Santa Cruz'),
('Santa Fe'),
('Santiago del Estero'),
('Tierra del Fuego'),
('Tucumán'),
('Ciudad Autónoma de Buenos Aires');

-- Inserts para la tabla LOCALIDADES 
INSERT INTO LOCALIDADES (Nombre) 
VALUES 
('La Plata'),
('Mar del Plata'),
('Bahía Blanca'),
('Tandil'),
('San Nicolás de los Arroyos'),
('Junín'),
('Pergamino'),
('Chivilcoy'),
('Zárate'),
('San Pedro'),
('Luján'),
('San Antonio de Areco'),
('Necochea'),
('Azul'),
('Olavarría'),
('La Matanza'),
('Tres de Febrero'),
('Morón'),
('San Isidro'),
('Tigre'),
('Vicente López'),
('Berazategui'),
('Quilmes'),
('Avellaneda'),
('San Fernando'),
('Escobar'),
('Merlo'),
('Moreno'),
('Lomas de Zamora'),
('Adrogué'),
('San Miguel'),
('Ituzaingó'),
('Berisso'),
('Ensenada'),
('Campana'),
('Villa Gesell'),
('Pinamar'),
('Mar de Ajó'),
('Miramar'),
('Cariló');

-- Inserts para la tabla usuarios
INSERT INTO USUARIOS (Usuario, Contrasenia, TipoUsuario) 
VALUES 
('admin', '123', 1),
('usuario1', 'password1', 2),
('usuario2', 'password2', 2),
('usuario3', 'password3', 2),
('usuario4', 'password4', 2),
('usuario5', 'password5', 2),
('usuario6', 'password6', 2),
('usuario7', 'password7', 2),
('usuario8', 'password8', 2),
('usuario9', 'password9', 2),
('usuario10', 'password10', 2),
('usuario11', 'password11', 2),
('usuario12', 'password12', 2),
('usuario13', 'password13', 2),
('usuario14', 'password14', 2);

-- Inserts para la tabla direcciones
INSERT INTO DIRECCIONES (IDProvincia, IDLocalidad, CodigoPostal, Calle, Numero) 
VALUES 
(1, 1, '1001', 'Avenida del Libertador', 100),
(1, 2, '1407', 'Calle Defensa', 250),
(1, 3, '1425', 'Calle Anchorena', 500),
(2, 1, '1043', 'Avenida Callao', 300),
(2, 1, '1428', 'Calle Azcuénaga', 750),
(1, 1, '1073', 'Avenida Las Heras', 450),
(5, 1, '1056', 'Calle Suipacha', 850),
(6, 1, '1089', 'Avenida 9 de Julio', 101),
(3, 1, '1168', 'Calle Armenia', 700),
(2, 1, '1181', 'Avenida San Juan', 320),
(5, 1, '1230', 'Calle Cabrera', 680),
(6, 1, '1333', 'Avenida Corrientes', 1200),
(7, 1, '1400', 'Calle Armenia', 90),
(5, 1, '1450', 'Avenida Santa Fe', 320),
(6, 1, '1520', 'Calle Parera', 550),
(8, 1, '1600', 'Avenida Córdoba', 250),
(2, 1, '1702', 'Calle Juncal', 620),
(8, 1, '1804', 'Avenida Alvear', 300);

-- Inserts para clientes
INSERT INTO CLIENTES (DNI, CUIL, Nombre, Apellido, Sexo, IDNacionalidad, Telefono, FechaNacimiento, IDDireccion, Email, IDUsuario, Estado) 
VALUES 
(55555555, '27-55555555-5', 'María', 'González', 'Femenino', 1, '112392392','1987-08-23', 2, 'maria.gonzalez@gmail.com', 2, true), 
(66666666, '20-66666666-6', 'Diego', 'Vega', 'Masculino', 1, '1532355324,', '1992-10-30', 3, 'diego.vega@gmail.com', 3, true),
(77777777, '27-77777777-7', 'Natalia', 'Ortiz', 'Femenino', 1, '21412434','1995-07-04', 4, 'natalia.ortiz@gmail.com', 4, true),
(88888888, '20-88888888-8', 'Fernando', 'Luna', 'Masculino', 1, '4322313241','1990-11-02', 5, 'fernando.luna@gmail.com', 5, true),
(99999999, '27-99999999-9', 'Valeria', 'Mendoza', 'Femenino', 1, '321312321','1989-03-12', 6, 'valeria.mendoza@gmail.com', 6, true),
(12345678, '20-12345678-1', 'Martín', 'Suárez', 'Masculino', 1, '11-54828','1996-04-20', 7, 'martin.suarez@gmail.com', 7, true),
(23456789, '27-23456789-2', 'Lucía', 'Pérez', 'Femenino', 1, '3211293','1994-12-15', 8, 'lucia.perez@gmail.com', 8, true),
(34567890, '20-34567890-3', 'Andrés', 'García', 'Masculino', 1, '23213122','1991-05-25', 9, 'andres.garcia@gmail.com', 9, true),
(45678901, '27-45678901-4', 'Sofía', 'López', 'Femenino', 1, '31231212', '1988-09-10', 10, 'sofia.lopez@gmail.com', 10, true),
(56789012, '20-56789012-5', 'Federico', 'Domínguez', 'Masculino', 1, '123123123', '1997-06-18', 11, 'federico.dominguez@gmail.com', 11, true),
(67890123, '27-67890123-6', 'Camila', 'Martínez', 'Femenino', 2, '11-2312332', '1993-03-08', 12, 'camila.martinez@gmail.com', 12, true),
(35632781, '27-35632781-4', 'Jose', 'Gonzales', 'Masculino', 3, '123123123','1989-10-15', 13, 'jose.gonzales@hotmail.com', 13, true),
(86784302, '20-86784302-5', 'Federico', 'Aguilar', 'Masculino', 4, '13-1242143','2001-06-18', 14, 'federico.aguilar@gmail.com', 14, true),
(57843223, '27-57843223-6', 'Tomas', 'Perez', 'Masculino', 5, '13-321312321', '1999-05-15', 15, 'tomas_perez@gmail.com', 15, true);

-- Inserts para cuentas
INSERT INTO CUENTAS(IDCliente, Saldo, IDTipoCuenta, ESTADO) 
VALUES
(1, 10000, 1, 1),
(1, 150000, 1, 1),
(2, 25000, 2, 1),
(2, 10000, 1, 1),
(3, 20000, 2, 1),
(3, 30000, 1, 1),
(3, 35000, 2, 1),
(4, 50000, 1, 1),
(4, 15000, 1, 1),
(5, 10000, 1, 1),
(5, 10000, 1, 1),
(6, 15000, 2, 1),
(8, 19000, 2, 1),
(10, 15000, 2, 1);

-- Inserts para movimientos
INSERT INTO MOVIMIENTOS(Fecha, DetalleOrigen, DetalleDestino, Importe, IDCuentaEmisor, IDCuentaReceptor, IDTipoMovimiento)
VALUES
('2024-04-15', 'Transferencia a Diego Vega','Transferencia recibida de Natalia Ortiz', 2700, 5, 2, 4);
/*
('2024-04-10', null, 'Ajuste administrativo', 3000, null, 6, 5)

('2024-04-20', '','Transferencia recibida de Andrés García', 15000, 13, 5, 4),
('2024-04-25', '','Transferencia recibida de Pedro Alfonso', 6000, 12, 5, 4),
('2024-05-05', '','Transferencia recibida de Armando Hernandéz', 4000, 11, 5, 4),
('2024-05-10', '','Transferencia recibida de Jose Perez', 25000, 11, 5, 4),
('2024-05-15', '','Transferencia recibida de Diego Gonzales', 4000, 11, 5, 4),
('2024-05-20', '','Transferencia recibida de Jose Gonzales', 25000, 11, 5, 4),
('2024-05-25', '','Transferencia recibida de Mario Hernandéz', 4000, 11, 5, 4),
('2024-06-05', '','Transferencia recibida de Jorge Perez', 25000, 11, 5, 4);
*/

-- Inserts para los tipo de préstamos 
INSERT INTO TIPO_PRESTAMOS (Tipo, TNA) 
VALUES 
('Personal', 25), -- TNA 25%
('Hipotecario', 5), -- TNA 10%
('Automotriz', 10), -- TNA 15%
('Vacaciones', 15), -- TNA 20%
('Comercial', 20), -- TNA 5%
('Agrícola', 18); -- TNA 10%

-- Inserts para préstamos
INSERT INTO PRESTAMOS (IDTipoPrestamo, IDCuenta, MontoPedido, ImporteAPagar, Cuotas, Fecha) 
VALUES 
(2, 1, 20000.00, 22000.00, 12, '2023-06-06'),   
(3, 1, 15000.00, 17250.00, 24, '2022-02-05'),   
(2, 1, 20000.00, 22000.00, 18, '2022-03-01'),   
(2, 2, 25000.00, 27500.00, 36, '2022-04-04'),   
(2, 2, 30000.00, 33000.00, 12, '2023-02-03'),   
(1, 2, 35000.00, 43750.00, 24, '2023-02-01'),  
(1, 3, 40000.00, 50000.00, 18, '2022-05-07'),
(5, 3, 40000.00, 50000.00, 18, '2022-05-07'),    
(4, 4, 45000.00, 54000.00, 36, '2023-08-01'),  
(5, 5, 50000.00, 52500.00, 12, '2023-09-08'),  
(1, 7, 55000.00, 68750.00, 24, '2023-10-01'), 
(1, 7, 35000.00, 43750.00, 24, '2023-02-01'),  
(1, 8, 40000.00, 50000.00, 18, '2022-05-07'),   
(4, 8, 45000.00, 54000.00, 36, '2023-08-01'),   
(5, 13, 50000.00, 52500.00, 12, '2023-09-08'),   
(1, 13, 55000.00, 68750.00, 24, '2023-10-01'),
(3, 10, 45000.00, 56250.00, 24, '2022-02-05'),   
(2, 10, 30000.00, 58000.00, 18, '2022-03-01'),
(5, 2, 50000.00, 52500.00, 12, '2023-09-11'),   
(1, 2, 55000.00, 68750.00, 24, '2023-10-13'),
(3, 2, 45000.00, 56250.00, 24, '2022-02-14'),   
(2, 2, 30000.00, 58000.00, 18, '2022-03-15'); 

