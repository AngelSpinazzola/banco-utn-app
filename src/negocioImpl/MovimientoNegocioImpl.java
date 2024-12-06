package negocioImpl;

import java.util.ArrayList;

import dao.IMovimientoDao;
import daoImpl.MovimientoDaoImpl;
import entidad.Movimiento;
import entidad.Prestamo;
import negocio.IMovimientoNegocio;

public class MovimientoNegocioImpl implements IMovimientoNegocio{
	IMovimientoDao iMovimientoDao;
	
	public MovimientoNegocioImpl() {
		this.iMovimientoDao = new MovimientoDaoImpl();
	}
	
	public void registrarMovimiento(Movimiento movimiento) {
		iMovimientoDao.registrarMovimiento(movimiento);
	}
	
	@Override
	public ArrayList<Movimiento> getMovimientosPorCliente(int idCliente, int page, int pageSize) {
		ArrayList<Movimiento> movimientos = iMovimientoDao.getMovimientosPorCliente(idCliente, page, pageSize);
		
		return movimientos;
	}
	
	@Override
	public int getTotalMovimientos(int idCliente) {
	    return iMovimientoDao.getTotalMovimientosPorCliente(idCliente);
	}
	
	
	@Override
	public int calcularTotalPaginas(int idCliente, int pageSize) {
	    int totalMovimientos = getTotalMovimientos(idCliente);
	    return (int) Math.ceil((double) totalMovimientos / pageSize);
	}
}