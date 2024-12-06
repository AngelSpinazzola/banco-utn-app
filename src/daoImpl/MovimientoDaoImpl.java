package daoImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import dao.IMovimientoDao;
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
	        
	        // Si el ID emisor es null, es un movimiento emitido por un administrador.
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
				"    cu.NumeroCuenta AS numeroCuenta,\r\n" + 
				"    m.IDMovimiento AS idMovimiento,\r\n" + 
				"    -- Solo muestra el detalle \"Traspaso de dinero entre cuentas\" si ambas cuentas son del mismo cliente\r\n" + 
				"    CASE \r\n" + 
				"        WHEN m.IDCuentaEmisor = cu.IDCuenta \r\n" + 
				"            AND cu.IDCliente = (SELECT IDCliente FROM CUENTAS WHERE IDCuenta = m.IDCuentaReceptor) THEN 'Traspaso de dinero entre cuentas'\r\n" + 
				"        ELSE \r\n" + 
				"            -- En caso contrario, el detalle corresponde al detalle de origen o destino\r\n" + 
				"            CASE \r\n" + 
				"                WHEN m.IDCuentaEmisor = cu.IDCuenta THEN m.DetalleOrigen\r\n" + 
				"                ELSE m.DetalleDestino\r\n" + 
				"            END\r\n" + 
				"    END AS detalle,\r\n" + 
				"    m.Fecha AS fecha,\r\n" + 
				"    m.Importe AS importe,\r\n" + 
				"    m.IDCuentaReceptor AS idCuentaReceptor,\r\n" + 
				"    tm.IDTipoMovimiento AS idTipo,\r\n" + 
				"    tm.Nombre AS nombreTipo\r\n" + 
				"FROM movimientos m\r\n" + 
				"INNER JOIN tipo_movimientos tm ON tm.IDTipoMovimiento = m.IDTipoMovimiento\r\n" + 
				"INNER JOIN cuentas cu ON cu.IDCuenta IN (m.IDCuentaEmisor, m.IDCuentaReceptor)\r\n" + 
				"WHERE cu.IDCliente = ?\r\n" + 
				"GROUP BY m.IDMovimiento\r\n" + 
				"ORDER BY m.Fecha DESC\r\n" + 
				"LIMIT ? OFFSET ?;\r\n" + 
				"";


		try (Connection conn = Conexion.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
	        ps.setInt(1, idCliente);          
	        ps.setInt(2, pageSize);          
	        ps.setInt(3, offset);             

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
	    String query = "SELECT COUNT(*) FROM movimientos m " +
	                   "INNER JOIN cuentas cu ON cu.IDCuenta = m.IDCuentaReceptor " +
	                   "WHERE cu.IDCliente = ?";

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