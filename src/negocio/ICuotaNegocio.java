package negocio;

import java.math.BigDecimal;
import java.util.ArrayList;
import entidad.Cuota;

public interface ICuotaNegocio {
	public ArrayList<Cuota> getCuotasPorPrestamo(int idPrestamo, int page, int pageSize);
	public int getTotalCuotasCount(int idPrestamo);
	public BigDecimal getMontoTotalCuotasAPagar(String idsCuotas);
}
