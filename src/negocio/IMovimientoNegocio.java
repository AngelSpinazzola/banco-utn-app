package negocio;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

import entidad.DatosDashboard;
import entidad.Movimiento;

public interface IMovimientoNegocio {
	public void registrarMovimiento(Movimiento movimiento);
	//public ArrayList<Movimiento> getMovimientosPorCliente(int idCliente, int page, int pageSize);
	public int calcularTotalPaginas(int idCliente, int pageSize);
	public int getTotalMovimientos(int idCliente);
	
	//Filtrado
	public ArrayList<Movimiento> getMovimientosFiltrados(int idCliente, String searchTerm, Double montoDesde, Double montoHasta, int page, int pageSize);
	public int getTotalMovimientosFiltrados(int idCliente, String searchTerm, Double montoDesde, Double montoHasta);
	
	// Métodos para reportes 
	public int getCantidadTransferenciasPorAnio(int anio);
	public BigDecimal getMontoTransferenciasPorAnio(int anio);
	public List<BigDecimal> getTransferenciasMensualesPorAnio(int anio);
	public List<Integer> getAniosConTransferencias();
}