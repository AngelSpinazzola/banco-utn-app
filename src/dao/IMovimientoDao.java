package dao;

import java.util.ArrayList;

import entidad.DatosDashboard;
import entidad.Movimiento;

public interface IMovimientoDao {
	public void registrarMovimiento(Movimiento movimiento);
	public int getTotalMovimientosPorCliente(int idCliente);
	
	//Filtrado
	public ArrayList<Movimiento> getMovimientosFiltrados(int idCliente, String searchTerm, Double montoDesde, Double montoHasta, int page, int pageSize);
	public int getTotalMovimientosFiltrados(int idCliente, String searchTerm, Double montoDesde, Double montoHasta);
}