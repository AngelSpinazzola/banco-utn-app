package negocioImpl;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import dao.IPrestamoDao;
import daoImpl.Conexion;
import daoImpl.PrestamoDaoImpl;
import entidad.Cuenta;
import entidad.Prestamo;
import negocio.IPrestamoNegocio;

public class PrestamoNegocioImpl implements IPrestamoNegocio{
	IPrestamoDao iPrestamoDao = new PrestamoDaoImpl();
	
	@Override
	public ArrayList<Prestamo> getPrestamosPorCliente(int idCliente, int page, int pageSize) {
		ArrayList<Prestamo> prestamos = iPrestamoDao.getPrestamosPorCliente(idCliente , page, pageSize);
		
		return prestamos;
	}
	
	@Override
	public ArrayList<Prestamo> getSolicitudesDePrestamos(int page, int pageSize){
		ArrayList<Prestamo> prestamos = iPrestamoDao.getSolicitudesDePrestamos(page, pageSize);
		
		return prestamos;
	}
	
	@Override
	public int getTotalSolicitudesPrestamosCount() {
		int totalSolicitudes = iPrestamoDao.getTotalSolicitudesPrestamosCount();
		
		return totalSolicitudes;
	}
	
	@Override
	public int getTotalPrestamosCount(int idCliente) {
	    return iPrestamoDao.getTotalPrestamosCount(idCliente); 
	}
	
	@Override
	public int getTotalPrestamosPorCliente(int idCliente) {
		return iPrestamoDao.getTotalPrestamosPorCliente(idCliente);
	}
	
	@Override
	public boolean pagarCuotasPrestamo(int idCuenta, String cuotasAPagar) {
		boolean resultado = iPrestamoDao.pagarCuotasPrestamo(idCuenta, cuotasAPagar);
		
		return resultado;
	}
	
	@Override
	public int calcularTotalPaginas(int idCliente, int pageSize) {
	    int totalPrestamos = getTotalPrestamosCount(idCliente); 
	    return (int) Math.ceil((double) totalPrestamos / pageSize);
	}
	
	@Override
	public int validarMonto(String monto) {
	    if (monto == null || monto.trim().isEmpty()) {
	        return -1;  // El campo no puede estar vacío
	    }

	    // Verifica si el monto es negativo
	    try {
	        if (Double.parseDouble(monto) < 0) {
	            return -2;  // El monto no puede ser negativo
	        }
	    } catch (NumberFormatException e) {
	        return -5;  // El monto contiene caracteres no numéricos
	    }

	    if (Double.parseDouble(monto) == 0) {
	        return -3;  
	    }

	    // Verifica que no contenga letras
	    if (monto.matches(".*[a-zA-Z]+.*")) {
	        return -4;  
	    }

	    // Verifica que no contenga letras ni símbolos no permitidos
	    if (!monto.matches("^\\d*(\\.\\d+)?$")) {
	        return -5;  
	    }

	    // Verifica que no tenga más de un punto decimal
	    if (monto.chars().filter(ch -> ch == '.').count() > 1) {
	        return -6;  
	    }
	    
	    double montoNumerico = Double.parseDouble(monto.replace(",", ""));
	    if (montoNumerico < 10000 || montoNumerico > 100000000) {
	        return -7;  // El monto debe estar entre 10,000 y 100,000,000
	    }

	    return 0; // Monto válido
	}
	
	@Override
	public boolean solicitarPrestamo(Prestamo prestamo, int idCuenta) {
		boolean resultado = iPrestamoDao.solicitarPrestamo(prestamo, idCuenta);
		
		return resultado;
	}
	
	
	@Override
	public boolean rechazarPrestamo(int idPrestamo) {
		boolean resultado = iPrestamoDao.rechazarPrestamo(idPrestamo);
		
		return resultado;
	}
	
	@Override
	public boolean aprobarPrestamo(int idPrestamo) {
		boolean resultado = iPrestamoDao.aprobarPrestamo(idPrestamo);
		
		return resultado;
	}
	
	@Override
	public int getTotalPrestamosCount() {
		return iPrestamoDao.getTotalPrestamosCount();
	}
	
	@Override
	public ArrayList<Prestamo> getPrestamos(int page, int pageSize){
		ArrayList<Prestamo> prestamos = iPrestamoDao.getPrestamos(page, pageSize); 
		
		return prestamos;
	}
	
	@Override
	public BigDecimal totalOtorgadoEnPrestamos() {
		BigDecimal saldo = iPrestamoDao.getTotalOtorgadoEnPrestamos();
		
		return saldo;
	}
	
	@Override
	public int getPrestamosCountPorCliente(int idCliente) {
		int total = iPrestamoDao.getPrestamosCountPorCliente(idCliente);
		
		return total;
	}
	
	@Override
	public int getPrestamosActivosCount() {
		int total = iPrestamoDao.getPrestamosActivosCount();
		
		return total;
	}
	
	// Métodos para reportes 
	@Override
	public int getCantidadPrestamosPorAnio(int anio) {
		String query = "select count(*) as cant from prestamos where year(fecha) = ? and Estado = 0";
		
		int totalPrestamos = 0;
		
		try (Connection conexion = Conexion.getConnection();
		   PreparedStatement statement = conexion.prepareStatement(query)) {
		   statement.setInt(1, anio);	
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
	public BigDecimal getMontoPrestamosPorAnio(int anio) {
		String query = "SELECT SUM(p.ImporteAPagar) AS suma_prestamos FROM prestamos p WHERE YEAR(p.fecha) = ? and p.Estado = 0";
		
		BigDecimal suma = BigDecimal.ZERO;
		
		try (Connection conn = Conexion.getConnection(); 
				PreparedStatement ps = conn.prepareStatement(query)) {
			ps.setInt(1, anio);
			ResultSet rs = ps.executeQuery();
			
			if (rs.next()) {
				suma = rs.getBigDecimal("suma_prestamos");
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return suma;
	}
	
	@Override
	public List<BigDecimal> getPrestamosMensualesPorAnio(int anio){
		String query = "SELECT MONTH(Fecha) AS Mes, SUM(p.MontoPedido) AS TotalPrestamos\r\n" + 
				"FROM PRESTAMOS p WHERE YEAR(Fecha) = ?\r\n" + 
				"GROUP BY MONTH(Fecha)\r\n" + 
				"ORDER BY Mes\r\n" + 
				"";
		
		List<BigDecimal> prestamosMensuales = new ArrayList<>();
	    
	    try (Connection conn = Conexion.getConnection();
	         PreparedStatement ps = conn.prepareStatement(query)) {
	        
	        ps.setInt(1, anio);
	        ResultSet rs = ps.executeQuery();
	        
	        for (int i = 0; i < 12; i++) {
	            prestamosMensuales.add(BigDecimal.ZERO);
	        }
	        
	        while (rs.next()) {
	            int mes = rs.getInt("Mes");
	            BigDecimal totalPrestamos = rs.getBigDecimal("TotalPrestamos");
	            
	            prestamosMensuales.set(mes - 1, totalPrestamos != null ? totalPrestamos : BigDecimal.ZERO);
	        }
	        
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    
	    return prestamosMensuales;
	}
	
	public List<Integer> getAniosConPrestamos() {
		String query = "SELECT DISTINCT YEAR(p.Fecha) FROM Prestamos p ORDER BY YEAR(p.Fecha) DESC";
		
		List<Integer> aniosConPrestamos = new ArrayList<>();

	    try (Connection conn = Conexion.getConnection();
	         PreparedStatement ps = conn.prepareStatement(query)) {
	        
	        ResultSet rs = ps.executeQuery();
	        
	        while (rs.next()) {
	            int anio = rs.getInt(1); 
	            aniosConPrestamos.add(anio);
	        }
	        
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    
	    return aniosConPrestamos;
		
	}


}