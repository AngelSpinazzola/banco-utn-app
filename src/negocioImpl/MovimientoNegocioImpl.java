package negocioImpl;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import dao.IMovimientoDao;
import daoImpl.Conexion;
import daoImpl.MovimientoDaoImpl;
import entidad.DatosDashboard;
import entidad.Movimiento;
import entidad.Prestamo;
import negocio.IMovimientoNegocio;

public class MovimientoNegocioImpl implements IMovimientoNegocio{
	IMovimientoDao iMovimientoDao;
	
	public MovimientoNegocioImpl() {
		this.iMovimientoDao = new MovimientoDaoImpl();
	}
	
	public void registrarMovimiento(Movimiento movimiento) {
		iMovimientoDao.registrarMovimiento(movimiento);
	}
	
	@Override
	public ArrayList<Movimiento> getMovimientosPorCliente(int idCliente, int page, int pageSize) {
		ArrayList<Movimiento> movimientos = iMovimientoDao.getMovimientosPorCliente(idCliente, page, pageSize);
		
		return movimientos;
	}
	
	@Override
	public int getTotalMovimientos(int idCliente) {
	    return iMovimientoDao.getTotalMovimientosPorCliente(idCliente);
	}
	
	
	@Override
	public int calcularTotalPaginas(int idCliente, int pageSize) {
	    int totalMovimientos = getTotalMovimientos(idCliente);
	    return (int) Math.ceil((double) totalMovimientos / pageSize);
	}
	
	//Métodos para reportes
	
	@Override
	public int getCantidadTransferenciasPorAnio(int anio) {
		String query = "select count(*) from movimientos where IDTipoMovimiento = 4 and year(fecha) = ?";
		
		int totalTransferencias = 0;
		
		try (Connection conexion = Conexion.getConnection();
		   PreparedStatement statement = conexion.prepareStatement(query)) {
		   statement.setInt(1, anio);	
			try (ResultSet rs = statement.executeQuery()) {
				if (rs.next()) {
					totalTransferencias = rs.getInt(1); 
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return totalTransferencias;
	}
	
	@Override
	public BigDecimal getMontoTransferenciasPorAnio(int anio) {
		String query = "SELECT SUM(m.Importe) as suma_transferencias FROM MOVIMIENTOS m WHERE m.IDTipoMovimiento = 4 AND YEAR(fecha) = ?";
		
		BigDecimal suma = BigDecimal.ZERO;
		
		try (Connection conn = Conexion.getConnection(); 
				PreparedStatement ps = conn.prepareStatement(query)) {
			ps.setInt(1, anio);
			ResultSet rs = ps.executeQuery();
			
			if (rs.next()) {
				suma = rs.getBigDecimal("suma_transferencias");
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return suma;
	}
	
}