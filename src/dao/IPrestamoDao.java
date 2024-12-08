package dao;

import java.util.ArrayList;
import entidad.Prestamo;

public interface IPrestamoDao {
	public ArrayList<Prestamo> getPrestamosPorCliente(int idCliente, int page, int pageSize);
	public int getTotalPrestamosCount(int idCliente);
	public int calcularTotalPaginas(int idCliente, int pageSize);
	public int getPrestamosPorCuenta(int idCuenta);
	public boolean solicitarPrestamo(Prestamo prestamo, int idCuenta);
}