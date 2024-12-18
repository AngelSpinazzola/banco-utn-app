package dao;

import java.util.ArrayList;

import entidad.DatosDashboard;
import entidad.Movimiento;

public interface IMovimientoDao {
	public void registrarMovimiento(Movimiento movimiento);
	public ArrayList<Movimiento> getMovimientosPorCliente(int idCliente, int page, int pageSize);
	public int getTotalMovimientosPorCliente(int idCliente);
}