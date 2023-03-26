use urbanMode;
DELIMITER //
CREATE PROCEDURE insert_user_rol(IN p_name VARCHAR(50), 
                                 IN p_email VARCHAR(255), 
                                 IN p_password VARCHAR(255), 
                                 IN p_active TINYINT(1), 
                                 IN p_rol_name VARCHAR(50), 
                                 IN p_rol_description VARCHAR(255))
BEGIN
    DECLARE user_id INT;
    DECLARE rol_id INT;
  DECLARE exit_error BOOLEAN DEFAULT FALSE;

START TRANSACTION;

INSERT INTO user (name, email, password, active) 
VALUES (p_name, p_email, p_password, p_active);

IF ROW_COUNT() <> 1 THEN
    SET exit_error = TRUE;
END IF;

SET user_id = LAST_INSERT_ID();

INSERT INTO role (name, description) 
VALUES (p_rol_name, p_rol_description);

IF ROW_COUNT() <> 1 THEN
    SET exit_error = TRUE;
END IF;

SET rol_id = LAST_INSERT_ID();

INSERT INTO roles_users (userId, roleId) 
VALUES (user_id, rol_id);

IF ROW_COUNT() <> 1 THEN
    SET exit_error = TRUE;
END IF;

IF exit_error THEN
    ROLLBACK;
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error al insertar en las 3 tablas';
ELSE
    COMMIT;
END IF;
END //
DELIMITER ;


call urbanmode.insert_user_rol('raul', 'raul@gmail.com', '123456', 1, 'admin', 'administrador');




DELIMITER //

CREATE PROCEDURE insert_user_rol(
    IN p_name VARCHAR(50), 
    IN p_email VARCHAR(255), 
    IN p_password VARCHAR(255), 
    IN p_active TINYINT(1), 
    IN p_rol_name VARCHAR(50), 
    IN p_rol_description VARCHAR(255)
)
BEGIN
    DECLARE user_id INT;
    DECLARE rol_id INT;
    DECLARE exit_handler BOOLEAN DEFAULT FALSE;
    
    DECLARE CONTINUE HANDLER FOR SQLSTATE '23000'
        SET exit_handler = TRUE;
    
    START TRANSACTION;
    
    INSERT INTO user (name, email, password, active) 
    VALUES (p_name, p_email, p_password, p_active);
    
    SET user_id = LAST_INSERT_ID();
    
    INSERT INTO role (name, description) 
    VALUES (p_rol_name, p_rol_description);
    
    SET rol_id = LAST_INSERT_ID();
    
    INSERT INTO roles_users (userId, roleId) 
    VALUES (user_id, rol_id);
    
    IF NOT (SELECT COUNT(*) FROM user WHERE id = user_id) = 1 OR
       NOT (SELECT COUNT(*) FROM role WHERE id = rol_id) =  1 OR
       NOT (SELECT COUNT(*) FROM roles_users WHERE userId = user_id AND roleId = rol_id) = 1 THEN
        SET exit_handler = TRUE;
    END IF;
    
    IF exit_handler THEN
        ROLLBACK;
    ELSE
        COMMIT;
    END IF;
END //

DELIMITER ;

drop procedure insert_user_rol;

call insert_user_rol('manuel munguia', 'MM@gmail.com', '345', 1, 'cliente', 'cliente nuevo');
call urbanmode.insert_user_rol('flores mesa', 'mesa@gmail.com', '1234', 1, 'cliente', 'cliente nuevo');

use urbanMode;
select * from user;
select * from role;
select * from roles_users;
select * from product;

insert into roles_users values(3,2);

drop table product;