package dao;

import java.math.BigDecimal;
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
	public int getTotalPrestamosCount();
	public ArrayList<Prestamo> getPrestamos(int page, int pageSize);
	public int getTotalPrestamosPorCliente(int idCliente);
	public boolean pagarCuotasPrestamo(int idCuenta, String cuotasAPagar);
	public BigDecimal getTotalOtorgadoEnPrestamos();
	
	public int getPrestamosCountPorCliente(int idCliente);
	public int getPrestamosActivosCount();
}