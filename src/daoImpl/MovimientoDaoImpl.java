package daoImpl;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import dao.IMovimientoDao;
import entidad.DatosDashboard;
import entidad.Movimiento;
import entidad.TipoMovimiento;

public class MovimientoDaoImpl implements IMovimientoDao {

	@Override
	public void registrarMovimiento(Movimiento movimiento) {
		Connection cn = null;
		String query = "INSERT INTO MOVIMIENTOS("
				+ "Fecha, Detalle, Importe, IDCuentaEmisor, IDCuentaReceptor, IDTipoMovimiento) "
				+ "VALUES (?, ?, ?, ?, ?, ?)";

		try (PreparedStatement statement = cn.prepareCall(query)) {
			cn = Conexion.getConnection();
			cn.setAutoCommit(false);
			
			statement.setDate(1, new java.sql.Date(movimiento.getFecha().getTime()));
	        statement.setString(2, movimiento.getDetalle());
	        statement.setBigDecimal(3, movimiento.getMonto());
	        
	        if (movimiento.getIdCuentaEmisor() != null) {
	            statement.setInt(4, movimiento.getIdCuentaEmisor());
	        } else {
	            statement.setNull(4, java.sql.Types.INTEGER);
	        }
	        statement.setInt(5, movimiento.getIdCuentaReceptor());
	        statement.setInt(6, movimiento.getTipoMovimiento().getId());
			
			
		} catch (SQLException e) {
			e.printStackTrace();
		} 

	}
	
	@Override
	public ArrayList<Movimiento> getMovimientosPorCliente(int idCliente, int page, int pageSize){
	    ArrayList<Movimiento> movimientos = new ArrayList<>();
	    int offset = (page - 1) * pageSize;
	    
	    String query = "SELECT \r\n" + 
	            "    m.IDMovimiento AS idMovimiento,\r\n" + 
	            "    CASE \r\n" + 
	            "        WHEN m.IDCuentaEmisor IN (SELECT IDCuenta FROM cuentas WHERE IDCliente = ?) THEN m.IDCuentaEmisor\r\n" + 
	            "        ELSE m.IDCuentaReceptor\r\n" + 
	            "    END AS idCuentaReceptor,\r\n" + 
	            "    m.Fecha AS fecha,\r\n" + 
	            "    m.Importe AS importe,\r\n" + 
	            "    CASE \r\n" + 
	            "        WHEN m.IDTipoMovimiento = 2 AND tp.Tipo IS NOT NULL THEN CONCAT('Préstamo ', tp.Tipo)\r\n" + 
	            "        WHEN m.IDTipoMovimiento = 2 THEN 'Préstamo'\r\n" + 
	            "        WHEN EXISTS (\r\n" + 
	            "            SELECT 1 FROM cuentas ce \r\n" + 
	            "            JOIN cuentas cr ON cr.IDCliente = ce.IDCliente \r\n" + 
	            "            WHERE ce.IDCuenta = m.IDCuentaEmisor \r\n" + 
	            "              AND cr.IDCuenta = m.IDCuentaReceptor\r\n" + 
	            "              AND ce.IDCliente = ?\r\n" + 
	            "        ) THEN 'Traspaso de dinero entre cuentas'\r\n" + 
	            "        WHEN m.IDCuentaEmisor IN (SELECT IDCuenta FROM cuentas WHERE IDCliente = ?) THEN m.DetalleOrigen\r\n" + 
	            "        ELSE m.DetalleDestino\r\n" + 
	            "    END AS detalle,\r\n" + 
	            "    tm.IDTipoMovimiento AS idTipo,\r\n" + 
	            "    tm.Nombre AS nombreTipo,\r\n" + 
	            "    cu.IDCliente AS clienteId\r\n" + 
	            "FROM movimientos m\r\n" + 
	            "INNER JOIN tipo_movimientos tm ON tm.IDTipoMovimiento = m.IDTipoMovimiento\r\n" + 
	            "LEFT JOIN prestamos p ON p.IDCuenta = m.IDCuentaReceptor AND p.Estado = 1\r\n" + 
	            "LEFT JOIN tipo_prestamos tp ON tp.IDTipoPrestamo = p.IDTipoPrestamo\r\n" + 
	            "INNER JOIN cuentas cu ON cu.IDCuenta IN (m.IDCuentaEmisor, m.IDCuentaReceptor)\r\n" + 
	            "WHERE cu.IDCliente = ?\r\n" + 
	            "GROUP BY m.IDMovimiento\r\n" + 
	            "ORDER BY m.Fecha DESC\r\n" + 
	            "LIMIT ? OFFSET ?";

	    try (Connection conn = Conexion.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
	        ps.setInt(1, idCliente);  
	        ps.setInt(2, idCliente);  
	        ps.setInt(3, idCliente);  
	        ps.setInt(4, idCliente);  
	        ps.setInt(5, pageSize);   
	        ps.setInt(6, offset);           
	        ResultSet rs = ps.executeQuery();
	        while (rs.next()) {
	            Movimiento movimiento = new Movimiento();
	            TipoMovimiento tipoMovimiento = new TipoMovimiento();
	            
	            tipoMovimiento.setId(rs.getInt("idTipo"));
	            tipoMovimiento.setNombre(rs.getString("nombreTipo"));
	            movimiento.setId(rs.getInt("idMovimiento"));
	            movimiento.setDetalle(rs.getString("detalle"));
	            movimiento.setFecha(rs.getDate("fecha"));
	            movimiento.setMonto(rs.getBigDecimal("importe"));
	            movimiento.setIdCuentaReceptor(rs.getInt("idCuentaReceptor"));
	            movimiento.setTipoMovimiento(tipoMovimiento);
	            movimientos.add(movimiento);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return movimientos;
	}
	
	@Override
	public int getTotalMovimientosPorCliente(int idCliente) {
	    String query = "SELECT COUNT(*) AS TotalMovimientos\r\n" + 
	    		"FROM MOVIMIENTOS M\r\n" + 
	    		"INNER JOIN CUENTAS C ON M.IDCuentaEmisor = C.IDCuenta OR M.IDCuentaReceptor = C.IDCuenta\r\n" + 
	    		"WHERE C.IDCliente = ?;";

	    int totalMovimientos = 0;

	    try (Connection conexion = Conexion.getConnection();
	         PreparedStatement statement = conexion.prepareStatement(query)) {

	        statement.setInt(1, idCliente);

	        try (ResultSet rs = statement.executeQuery()) {
	            if (rs.next()) {
	                totalMovimientos = rs.getInt(1); 
	            }
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return totalMovimientos;
	}



}