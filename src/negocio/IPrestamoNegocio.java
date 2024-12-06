package negocio;

import java.util.ArrayList;
import entidad.Prestamo;

public interface IPrestamoNegocio {
	public ArrayList<Prestamo> getPrestamosPorCliente(int idCliente, int page, int pageSize);
	public int getTotalPrestamosCount(int idCliente);
	public int calcularTotalPaginas(int idCliente, int pageSize);
	public int validarMonto(String monto);
}