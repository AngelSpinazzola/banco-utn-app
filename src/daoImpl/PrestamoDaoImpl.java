package daoImpl;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import dao.IPrestamoDao;
import entidad.Prestamo;
import entidad.TipoPrestamo;

public class PrestamoDaoImpl implements IPrestamoDao {

	@Override
	public ArrayList<Prestamo> getPrestamosPorCliente(int idCliente, int page, int pageSize) {
		ArrayList<Prestamo> prestamos = new ArrayList<>();

		int offset = (page - 1) * pageSize;

		String query = "SELECT \r\n" + 
				"    p.IDPrestamo AS idPrestamo,\r\n" + 
				"    p.IDTipoPrestamo AS idTipoPrestamo,\r\n" + 
				"    p.MontoPedido AS montoPedido,\r\n" + 
				"    p.ImporteAPagar AS importeAPagar,\r\n" + 
				"    p.Cuotas AS cuotas,\r\n" + 
				"    p.Fecha AS fecha,\r\n" + 
				"    p.Estado AS estado,\r\n" + 
				"    tp.Tipo AS tipoPrestamo,\r\n" + 
				"    tp.TNA AS tna\r\n" + 
				"FROM prestamos p\r\n" + 
				"INNER JOIN cuentas cu ON cu.IDCuenta = p.IDCuenta\r\n" + 
				"INNER JOIN clientes c ON c.IDCliente = cu.IDCliente\r\n" + 
				"INNER JOIN tipo_prestamos tp ON tp.IDTipoPrestamo = p.IDTipoPrestamo\r\n" + 
				"WHERE cu.IDCliente = ? \r\n" + 
				"LIMIT ? OFFSET ?\r\n" + 
				"";

		try (Connection conn = Conexion.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
			ps.setInt(1, idCliente);
			ps.setInt(2, pageSize);
			ps.setInt(3, offset);
			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				Prestamo prestamo = new Prestamo();
				TipoPrestamo tipoPrestamo = new TipoPrestamo();
				
				prestamo.setIdPrestamo(rs.getInt("idPrestamo"));
				prestamo.setMontoAPagar(rs.getBigDecimal("importeAPagar"));
				prestamo.setMontoPedido(rs.getBigDecimal("montoPedido"));
				prestamo.setCuotas(rs.getInt("cuotas"));
				prestamo.setFecha(rs.getDate("fecha"));
				prestamo.setEstado(rs.getInt("estado"));
				
				tipoPrestamo.setIdTipoPrestamo(rs.getInt("idTipoPrestamo"));
				tipoPrestamo.setNombreTipoPrestamo(rs.getString("tipoPrestamo"));
				tipoPrestamo.setTna(rs.getBigDecimal("tna"));
				
				prestamo.setTipoPrestamo(tipoPrestamo);
				
				prestamos.add(prestamo);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return prestamos;
	}

	@Override
	public int getTotalPrestamosCount(int idCliente) {
		String query = "select count(*) from prestamos p\r\n" + 
				"inner join cuentas cu on cu.IDCuenta = p.IDCuenta\r\n" + 
				"inner join clientes c on c.IDCliente = cu.IDCliente\r\n" + 
				"where c.IDCliente = ?";

		int totalPrestamos = 0;

		try (Connection conexion = Conexion.getConnection();
				PreparedStatement statement = conexion.prepareStatement(query)) {

			statement.setInt(1, idCliente);

			try (ResultSet rs = statement.executeQuery()) {
				if (rs.next()) {
					totalPrestamos = rs.getInt(1); 
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return totalPrestamos;
	}

	@Override
	public int calcularTotalPaginas(int idCliente, int pageSize) {
	    int totalPrestamos = getTotalPrestamosCount(idCliente); 
	    return (int) Math.ceil((double) totalPrestamos / pageSize); 
	}
	
	@Override
	public int getPrestamosPorCuenta(int idCuenta) {
		String query = "select count(*) from prestamos where IDCuenta = ?";
		
		int totalPrestamos = 0;
		
		try (Connection conexion = Conexion.getConnection();
				PreparedStatement statement = conexion.prepareStatement(query)) {

			statement.setInt(1, idCuenta);

			try (ResultSet rs = statement.executeQuery()) {
				if (rs.next()) {
					totalPrestamos = rs.getInt(1); 
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return totalPrestamos;
	}
	
	@Override
	public boolean solicitarPrestamo(Prestamo prestamo, int idCuenta) {
	    boolean resultado = false;

	    try (Connection conexion = Conexion.getConnection()) {
	        try (CallableStatement stmt = conexion.prepareCall("{CALL InsertarPrestamo(?, ?, ?, ?, ?)}")) {
	            stmt.setInt(1, prestamo.getTipoPrestamo().getIdTipoPrestamo());
	            stmt.setInt(2, idCuenta);
	            stmt.setBigDecimal(3, prestamo.getMontoPedido());
	            stmt.setInt(4, prestamo.getCuotas());

	            stmt.registerOutParameter(5, java.sql.Types.BOOLEAN); 

	            stmt.executeUpdate();

	            resultado = stmt.getBoolean(5);  
	        } catch (SQLException e) {
	            e.printStackTrace();
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    
	    return resultado;
	}

}