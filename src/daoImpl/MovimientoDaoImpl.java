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
	
	public ArrayList<Movimiento> getMovimientosFiltrados(int idCliente, String searchTerm, Double montoDesde, Double montoHasta, int page, int pageSize) {
	    ArrayList<Movimiento> movimientos = new ArrayList<>();
	    int offset = (page - 1) * pageSize;
	    
	    StringBuilder queryBuilder = new StringBuilder(
	        "SELECT \r\n" + 
	        "    m.IDMovimiento AS idMovimiento,\r\n" + 
	        "    CASE \r\n" + 
	        "        WHEN m.IDCuentaEmisor IN (SELECT IDCuenta FROM cuentas WHERE IDCliente = ?) THEN m.IDCuentaEmisor\r\n" + 
	        "        ELSE m.IDCuentaReceptor\r\n" + 
	        "    END AS idCuentaReceptor,\r\n" + 
	        "    m.Fecha AS fecha,\r\n" + 
	        "    m.Importe AS importe,\r\n" + 
	        "    CASE \r\n" + 
	        "        WHEN m.IDTipoMovimiento = 2 AND tp.Tipo IS NOT NULL THEN CONCAT('Pr�stamo ', tp.Tipo)\r\n" + 
	        "        WHEN m.IDTipoMovimiento = 2 THEN 'Pr�stamo'\r\n" + 
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
	        "WHERE cu.IDCliente = ?\r\n");

	    // Agrega condiciones de filtrado
	    if (searchTerm != null && !searchTerm.trim().isEmpty()) {
	        queryBuilder.append(" AND (m.DetalleOrigen LIKE ? OR m.DetalleDestino LIKE ? OR tm.Nombre LIKE ?)\r\n");
	    }
	    
	    if (montoDesde != null) {
	        queryBuilder.append(" AND m.Importe >= ?\r\n");
	    }
	    
	    if (montoHasta != null) {
	        queryBuilder.append(" AND m.Importe <= ?\r\n");
	    }
	    
	    queryBuilder.append("GROUP BY m.IDMovimiento\r\n");
	    queryBuilder.append("ORDER BY m.Fecha DESC\r\n");
	    queryBuilder.append("LIMIT ? OFFSET ?");

	    try (Connection conn = Conexion.getConnection();
	         PreparedStatement ps = conn.prepareStatement(queryBuilder.toString())) {
	        
	        int parameterIndex = 1;
	        
	        // Par�metros base de la query
	        ps.setInt(parameterIndex++, idCliente);
	        ps.setInt(parameterIndex++, idCliente);
	        ps.setInt(parameterIndex++, idCliente);
	        ps.setInt(parameterIndex++, idCliente);

	        // Par�metros de b�squeda
	        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
	            String searchPattern = "%" + searchTerm + "%";
	            ps.setString(parameterIndex++, searchPattern);
	            ps.setString(parameterIndex++, searchPattern);
	            ps.setString(parameterIndex++, searchPattern);
	        }
	        
	        // Par�metros de rango de monto
	        if (montoDesde != null) {
	            ps.setDouble(parameterIndex++, montoDesde);
	        }
	        
	        if (montoHasta != null) {
	            ps.setDouble(parameterIndex++, montoHasta);
	        }
	        
	        // Par�metros de paginaci�n
	        ps.setInt(parameterIndex++, pageSize);
	        ps.setInt(parameterIndex, offset);

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

	public int getTotalMovimientosFiltrados(int idCliente, String searchTerm, Double montoDesde, Double montoHasta) {
	    int total = 0;
	    
	    StringBuilder queryBuilder = new StringBuilder(
	        "SELECT COUNT(DISTINCT m.IDMovimiento) as total\r\n" + 
	        "FROM movimientos m\r\n" + 
	        "INNER JOIN tipo_movimientos tm ON tm.IDTipoMovimiento = m.IDTipoMovimiento\r\n" + 
	        "INNER JOIN cuentas cu ON cu.IDCuenta IN (m.IDCuentaEmisor, m.IDCuentaReceptor)\r\n" + 
	        "WHERE cu.IDCliente = ?\r\n");

	    if (searchTerm != null && !searchTerm.trim().isEmpty()) {
	        queryBuilder.append(" AND (m.DetalleOrigen LIKE ? OR m.DetalleDestino LIKE ? OR tm.Nombre LIKE ?)\r\n");
	    }
	    
	    if (montoDesde != null) {
	        queryBuilder.append(" AND m.Importe >= ?\r\n");
	    }
	    
	    if (montoHasta != null) {
	        queryBuilder.append(" AND m.Importe <= ?\r\n");
	    }

	    try (Connection conn = Conexion.getConnection();
	         PreparedStatement ps = conn.prepareStatement(queryBuilder.toString())) {
	        
	        int parameterIndex = 1;
	        ps.setInt(parameterIndex++, idCliente);

	        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
	            String searchPattern = "%" + searchTerm + "%";
	            ps.setString(parameterIndex++, searchPattern);
	            ps.setString(parameterIndex++, searchPattern);
	            ps.setString(parameterIndex++, searchPattern);
	        }
	        
	        if (montoDesde != null) {
	            ps.setDouble(parameterIndex++, montoDesde);
	        }
	        
	        if (montoHasta != null) {
	            ps.setDouble(parameterIndex++, montoHasta);
	        }

	        ResultSet rs = ps.executeQuery();
	        if (rs.next()) {
	            total = rs.getInt("total");
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return total;
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