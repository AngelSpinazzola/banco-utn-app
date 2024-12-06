package negocio;

import java.util.ArrayList;

import entidad.Movimiento;

public interface IMovimientoNegocio {
	public void registrarMovimiento(Movimiento movimiento);
	public ArrayList<Movimiento> getMovimientosPorCliente(int idCliente, int page, int pageSize);
	public int calcularTotalPaginas(int idCliente, int pageSize);
	public int getTotalMovimientos(int idCliente);
}