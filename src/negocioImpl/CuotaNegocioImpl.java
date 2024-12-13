package negocioImpl;

import java.math.BigDecimal;
import java.util.ArrayList;
import dao.ICuotaDao;
import daoImpl.CuotaDaoImpl;
import entidad.Cuota;
import negocio.ICuotaNegocio;

public class CuotaNegocioImpl implements ICuotaNegocio{
	ICuotaDao iCuotaDao = new CuotaDaoImpl();
	
	@Override
	public ArrayList<Cuota> getCuotasPorPrestamo(int idPrestamo, int page, int pageSize){
		ArrayList<Cuota> cuotas = iCuotaDao.getCuotasPorPrestamo(idPrestamo, page, pageSize);
		
		return cuotas;
	}
	
	@Override
	public int getTotalCuotasCount(int idPrestamo) {
		return iCuotaDao.getTotalCuotasCount(idPrestamo);
	}
	
	@Override
	public BigDecimal getMontoTotalCuotasAPagar(String idsCuotas){
		BigDecimal montoTotal = iCuotaDao.getMontoTotalCuotasAPagar(idsCuotas);
		
		return montoTotal;
	}
}
