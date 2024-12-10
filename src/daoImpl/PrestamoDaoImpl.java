package daoImpl;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import dao.IPrestamoDao;
import entidad.Cliente;
import entidad.Movimiento;
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
	public int getTotalPrestamosActivosCount() {
		String query = "select count(*) from prestamos where Estado = 1";
		
		int totalPrestamosActivos = 0;

		try (Connection conexion = Conexion.getConnection();
				PreparedStatement statement = conexion.prepareStatement(query)) {


			try (ResultSet rs = statement.executeQuery()) {
				if (rs.next()) {
					totalPrestamosActivos = rs.getInt(1); 
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return totalPrestamosActivos;
	}
	
	@Override
	public ArrayList<Prestamo> getPrestamosActivos(int page, int pageSize){
		ArrayList<Prestamo> prestamos = new ArrayList<>();

		int offset = (page - 1) * pageSize;
		
		String query = "{CALL SP_ListarPrestamosActivos(?,?)}";
		
		try (Connection conn = Conexion.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
			ps.setInt(1, pageSize);
			ps.setInt(2, offset);
			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				TipoPrestamo tipoPrestamo = new TipoPrestamo();
				tipoPrestamo.setNombreTipoPrestamo(rs.getString("tipoPrestamo"));
				
				Cliente cliente = new Cliente();
				cliente.setNombre(rs.getString("nombre"));
				cliente.setApellido(rs.getString("apellido"));
				
				Prestamo prestamo = new Prestamo();
				
				prestamo.setIdPrestamo(rs.getInt("idPrestamo"));
				prestamo.setCliente(cliente);
				prestamo.setMontoPedido(rs.getBigDecimal("montoPedido"));
				prestamo.setMontoAPagar(rs.getBigDecimal("importeAPagar"));
				prestamo.setTipoPrestamo(tipoPrestamo);
				prestamo.setCuotas(rs.getInt("cuotasTotales"));
				prestamo.setCuotasPagas(rs.getInt("cuotasAbonadas"));
				prestamo.setFecha(rs.getDate("fechaAprobacion"));
				prestamo.setEstado(rs.getInt("estado"));
				
				prestamos.add(prestamo);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return prestamos;
	
	}
	
	
	public int getTotalSolicitudesPrestamosCount() {
		String query = "select count(p.IDPrestamo) from prestamos p where p.Estado = 0";
		
		int totalSolicitudes = 0;
		
		try (Connection conexion = Conexion.getConnection();
				PreparedStatement statement = conexion.prepareStatement(query)) {

			try (ResultSet rs = statement.executeQuery()) {
				if (rs.next()) {
					totalSolicitudes = rs.getInt(1); 
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return totalSolicitudes;
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

	@Override
	public ArrayList<Prestamo> getSolicitudesDePrestamos(int page, int pageSize){
		ArrayList<Prestamo> prestamos = new ArrayList<>();
		
		int offset = (page - 1) * pageSize;
		
		String query = "select \r\n" + 
				"	p.IDPrestamo as idPrestamo,\r\n" + 
				"	c.Nombre as nombre, \r\n" + 
				"    c.Apellido as apellido,\r\n" + 
				"    c.DNI as dni,\r\n" + 
				"    p.MontoPedido as montoPedido,\r\n" + 
				"    p.ImporteAPagar as importeAPagar,\r\n" + 
				"    p.Cuotas as cuotas,\r\n" + 
				"    tp.Tipo as tipoPrestamo,\r\n" + 
				"    p.Fecha as fechaSolicitud\r\n" + 
				"from prestamos p\r\n" + 
				"inner join tipo_prestamos tp on tp.IDTipoPrestamo = p.IDTipoPrestamo\r\n" + 
				"inner join cuentas cu on cu.IDCuenta = p.IDCuenta\r\n" + 
				"inner join clientes c on c.IDCliente = cu.IDCliente\r\n" + 
				"where p.Estado = 0\r\n" + 
				"order by fechaSolicitud desc\r\n" + 
				"limit ? offset ?";
		try (Connection conn = Conexion.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
	        ps.setInt(1, pageSize);
	        ps.setInt(2, offset);
	        
	        ResultSet rs = ps.executeQuery();
	        
	        while (rs.next()) {
	            Cliente cliente = new Cliente();
	            cliente.setNombre(rs.getString("nombre"));
	            cliente.setApellido(rs.getString("apellido"));
	            cliente.setDni(rs.getString("dni"));
	            
	            Prestamo prestamo = new Prestamo();
	            prestamo.setIdPrestamo(rs.getInt("idPrestamo"));
	            prestamo.setMontoPedido(rs.getBigDecimal("montoPedido"));
	            prestamo.setMontoAPagar(rs.getBigDecimal("importeAPagar"));
	            prestamo.setCuotas(rs.getInt("cuotas"));
	            prestamo.setFecha(rs.getDate("fechaSolicitud"));
	            
	            TipoPrestamo tipoPrestamo = new TipoPrestamo();
	            tipoPrestamo.setNombreTipoPrestamo(rs.getString("tipoPrestamo"));
	            
	            prestamo.setTipoPrestamo(tipoPrestamo);
	            prestamo.setCliente(cliente);
	            
	            prestamos.add(prestamo);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    
	    return prestamos;
		
	}
	
	@Override
	public boolean rechazarPrestamo(int idPrestamo) {
	    String query = "UPDATE prestamos SET Estado = 2 WHERE IDPrestamo = ?";
	    boolean resultado = false;
	    
	    try (Connection conexion = Conexion.getConnection();
	         PreparedStatement statement = conexion.prepareStatement(query)) {
	         
	        statement.setInt(1, idPrestamo);
	        
	        int filasAfectadas = statement.executeUpdate();
	        
	        if (filasAfectadas > 0) {
	            resultado = true;
	        }
	    } catch (Exception e) {
	        e.printStackTrace(); 
	    }
	    
	    return resultado;
	}
	
	@Override
	public boolean aprobarPrestamo(int idPrestamo) {
		String query = "{CALL SP_AprobarPrestamo(?)}";
		
		boolean resultado = false;
	    
	    try (Connection conexion = Conexion.getConnection();
	         PreparedStatement statement = conexion.prepareStatement(query)) {
	         
	        statement.setInt(1, idPrestamo);
	        
	        int filasAfectadas = statement.executeUpdate();
	        
	        if (filasAfectadas > 0) {
	            resultado = true;
	        }
	    } catch (Exception e) {
	        e.printStackTrace(); 
	    }
	    
	    return resultado;
	}

}