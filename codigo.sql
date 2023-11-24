/***************
    PUNTO 4
****************/
CREATE TABLE Empleados (
    ID NUMBER PRIMARY KEY,
    Nombre VARCHAR2(50),
    Puesto VARCHAR2(50),
    Salario NUMBER
);
    /*
    insert into Empleados values (1,'Pepito','Agente',10000);
    insert into Empleados values (2,'Juanito','Agente',10000);
    insert into Empleados values (3,'Sara','Lider tecnico',50000);
    insert into Empleados values (4,'Nicole','Manager',100000);
    */

/***************
    PUNTO 5
****************/
CREATE OR REPLACE PROCEDURE AumentarSalario(
    p_ID IN NUMBER,
    p_PorcentajeAumento IN NUMBER
)
IS
    v_SalarioActual NUMBER;
BEGIN
    -- Verificar si el empleado existe
    SELECT Salario INTO v_SalarioActual FROM Empleados WHERE ID = p_ID;

    IF SQL%NOTFOUND THEN
        -- Si no se encuentra el empleado, mostrar mensaje de error
        DBMS_OUTPUT.PUT_LINE('El empleado con ID ' || p_ID || ' no existe.');
    ELSE
        -- Calcular el nuevo salario aumentado por el porcentaje
        v_SalarioActual := v_SalarioActual * (1 + (p_PorcentajeAumento / 100));

        -- Actualizar el salario del empleado
        UPDATE Empleados SET Salario = v_SalarioActual WHERE ID = p_ID;

        DBMS_OUTPUT.PUT_LINE('El salario del empleado con ID ' || p_ID || ' ha sido aumentado en ' || p_PorcentajeAumento || '%.');
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se encontró el empleado con ID ' || p_ID || '.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ocurrió un error al aumentar el salario del empleado.');
END;


/***************
    PUNTO 6
****************/
CREATE OR REPLACE FUNCTION CalcularBonificacion (p_salario NUMBER)
RETURN NUMBER
IS
    v_bonificacion NUMBER;
BEGIN
    IF p_salario <= 30000 THEN
        v_bonificacion := p_salario * 0.20; -- 20% del salario
    ELSIF p_salario <= 50000 THEN
        v_bonificacion := p_salario * 0.15; -- 15% del salario
    ELSE
        v_bonificacion := p_salario * 0.10; -- 10% del salario
    END IF;

    RETURN v_bonificacion; -- Devolver el monto de bonificación calculado
END;
/

/***************
    PUNTO 7
****************/
CREATE SEQUENCE seq_empleados
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE OR REPLACE TRIGGER trg_generar_id_empleado
BEFORE INSERT ON empleados
FOR EACH ROW
BEGIN
    IF :NEW.ID IS NULL THEN -- Verifica si no se proporciona un ID en la inserción
        SELECT seq_empleados.NEXTVAL INTO :NEW.ID FROM dual;
    END IF;
END;
/

/***************
    PUNTO 8
****************/

CCREATE OR REPLACE TYPE venta_registro AS OBJECT (
    ID_Venta NUMBER,
    Monto_Venta NUMBER
);
/

CREATE OR REPLACE TYPE venta_tabla AS TABLE OF venta_registro;
/

CREATE OR REPLACE FUNCTION obtener_ventas_empleado(p_id_empleado NUMBER)
RETURN venta_tabla
IS
    v_ventas venta_tabla := venta_tabla(); -- Colección de registros de ventas
    v_index NUMBER := 1;
BEGIN
    FOR venta IN (SELECT ID_Venta, Valor_Venta
                  FROM ventas
                  WHERE ID_Empleado = p_id_empleado)
    LOOP
        v_ventas.EXTEND;
        v_ventas(v_index) := venta_registro(venta.ID_Venta, venta.Valor_Venta);
        v_index := v_index + 1;
    END LOOP;

    RETURN v_ventas;
END;
/


/***************
    PUNTO 9
****************/

/*a)*/
SELECT *
FROM empleados
WHERE Salario BETWEEN 40000 AND 60000;

/*b)*/
SELECT AVG(Salario) AS SalarioPromedio
FROM empleados;

/*c)*/
SELECT COUNT(*)
FROM empleados
WHERE Salario > 70000;
