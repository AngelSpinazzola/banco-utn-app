package negocioImpl;

import java.util.ArrayList;
import dao.IPrestamoDao;
import daoImpl.PrestamoDaoImpl;
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
	public int getTotalPrestamosCount(int idCliente) {
	    return iPrestamoDao.getTotalPrestamosCount(idCliente); 
	}
	
	@Override
	public int calcularTotalPaginas(int idCliente, int pageSize) {
	    int totalPrestamos = getTotalPrestamosCount(idCliente); 
	    return (int) Math.ceil((double) totalPrestamos / pageSize);
	}
	
	@Override
	public int validarMonto(String monto) {
	    if (monto == null || monto.trim().isEmpty()) {
	        return -1;  // El campo no puede estar vac�o
	    }

	    // Verifica si el monto es negativo
	    try {
	        if (Double.parseDouble(monto) < 0) {
	            return -2;  // El monto no puede ser negativo
	        }
	    } catch (NumberFormatException e) {
	        return -5;  // El monto contiene caracteres no num�ricos
	    }

	    if (Double.parseDouble(monto) == 0) {
	        return -3;  
	    }

	    // Verifica que no contenga letras
	    if (monto.matches(".*[a-zA-Z]+.*")) {
	        return -4;  
	    }

	    // Verifica que no contenga letras ni s�mbolos no permitidos
	    if (!monto.matches("^\\d*(\\.\\d+)?$")) {
	        return -5;  
	    }

	    // Verifica que no tenga m�s de un punto decimal
	    if (monto.chars().filter(ch -> ch == '.').count() > 1) {
	        return -6;  
	    }

	    return 0; // Monto v�lido
	}


}