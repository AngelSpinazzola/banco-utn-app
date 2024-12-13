package dao;

import java.math.BigDecimal;
import java.util.ArrayList;
import entidad.Cuota;

public interface ICuotaDao {
	public ArrayList<Cuota> getCuotasPorPrestamo(int idPrestamo, int page, int pageSize);
	public int getTotalCuotasCount(int idPrestamo);
	public BigDecimal getMontoTotalCuotasAPagar(String idsCuotas);
}
