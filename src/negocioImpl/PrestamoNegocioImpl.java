package negocioImpl;

import java.util.ArrayList;
import dao.IPrestamoDao;
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
	public int getTotalPrestamosActivosPorCliente(int idCliente) {
		return iPrestamoDao.getTotalPrestamosActivosPorCliente(idCliente);
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
	public int getTotalPrestamosActivosCount() {
		return iPrestamoDao.getTotalPrestamosActivosCount();
	}
	
	@Override
	public ArrayList<Prestamo> getPrestamosActivos(int page, int pageSize){
		ArrayList<Prestamo> prestamos = iPrestamoDao.getPrestamosActivos(page, pageSize); 
		
		return prestamos;
	}

}