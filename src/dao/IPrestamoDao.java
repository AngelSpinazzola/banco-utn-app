package dao;

import java.util.ArrayList;
import entidad.Prestamo;

public interface IPrestamoDao {
	public ArrayList<Prestamo> getPrestamosPorCliente(int idCliente, int page, int pageSize);
	public int getTotalPrestamosCount(int idCliente);
	public int getTotalSolicitudesPrestamosCount();
	public int calcularTotalPaginas(int idCliente, int pageSize);
	public int getPrestamosPorCuenta(int idCuenta);
	public boolean solicitarPrestamo(Prestamo prestamo, int idCuenta);
	public ArrayList<Prestamo> getSolicitudesDePrestamos(int page, int pageSize);
	public boolean rechazarPrestamo(int idPrestamo);
	public boolean aprobarPrestamo(int idPrestamo);
	public int getTotalPrestamosActivosCount();
	public ArrayList<Prestamo> getPrestamosActivos(int page, int pageSize);
	public int getTotalPrestamosActivosPorCliente(int idCliente);
}