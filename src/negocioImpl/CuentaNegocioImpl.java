package negocioImpl;

import java.math.BigDecimal;
import java.util.ArrayList;
import dao.ICuentaDao;
import daoImpl.CuentaDaoImpl;
import entidad.Cuenta;
import negocio.ICuentaNegocio;

public class CuentaNegocioImpl implements ICuentaNegocio{
	ICuentaDao iCuentaDao = new CuentaDaoImpl();
	
	@Override
	public ArrayList<Cuenta> getCuentasDelCliente(int idCliente) {
		ArrayList<Cuenta> cuentas = iCuentaDao.getCuentasDelCliente(idCliente);
		
		return cuentas;
	}
	
	@Override
	public int agregarCuenta(int idCliente, int idTipoCuenta) {
		int resultado = iCuentaDao.agregarCuenta(idCliente, idTipoCuenta);
		
		return resultado; 
	}
	
	public BigDecimal getSaldoCuentaCliente(int idCuenta) {
		BigDecimal saldo = iCuentaDao.getSaldoCuentaCliente(idCuenta);
		
		return saldo;
	}
	
	@Override
	public boolean modificarSaldo(int idCuenta, BigDecimal saldoNuevo) {
		
		boolean resultado = iCuentaDao.modificarSaldo(idCuenta, saldoNuevo);
		
		return resultado;
	}
	
	@Override
	public int eliminarCuenta(int idCuenta) {
		int resultado = iCuentaDao.eliminarCuenta(idCuenta); 
		
		return resultado;
	}
	
	@Override
	public int validarTransferencia(String cbuOrigen, String cbuDestino, String monto) {
		
		if (cbuOrigen.equals(cbuDestino)) {
	        return -1; //Indica que los CBUS son iguales.
	    }
		
		if (!validarMonto(monto)) {
	        return -2; //Si el monto no es válido, retorna un código de error -2 
	    }
		
	    BigDecimal montoBigDecimal = new BigDecimal(monto);
		
		if (!validarSaldo(montoBigDecimal, cbuOrigen)) {
			return -3; //Si no hay suficiente saldo, retorna un código de error 3
	    }
		
		if(!validarCuentaDestino(cbuDestino)) {
			return -4; //Indica que el CBU destino no existe.
		}
		
		return 0; // Si retorna 0, se validaron todos los pasos
	}
	
	@Override
	public boolean validarMonto(String monto) {
		if (monto == null || monto.trim().isEmpty()) {
	        return false;  // El monto no puede ser null ni vacío
	    }
		
		// Verifica que no contenga letras ni símbolos no permitidos
	    if (monto.matches(".*[a-zA-Z]+.*")) {
	        return false;  
	    }
	    
	    // Verifica que no contenga los símbolos '+' o '-'
	    if (monto.contains("+") || monto.contains("-")) {
	        return false;  
	    }
	    
	    // Verifica que el monto sea numérico (permite un solo punto decimal)
	    if (!monto.matches("^\\d*(\\.\\d+)?$")) {
	        return false;  
	    }
		
		return true;
	}
	
	@Override
	public boolean validarSaldo(BigDecimal monto, String cbuOrigen) {
		boolean resultado = iCuentaDao.validarSaldo(monto, cbuOrigen);
		return resultado;
	}
	
	@Override
	public boolean validarCuentaDestino(String cbuDestino) {
		boolean resultado = iCuentaDao.validarCuentaDestino(cbuDestino);
		return resultado;
	}
	
	@Override
	public boolean realizarTransferencia(String cbuOrigen, String cbuDestino, String monto) {
		boolean resultado = iCuentaDao.transferir(cbuOrigen, cbuDestino, monto);
		return resultado;
	}
	
	@Override
	public boolean tieneCuentas(int idCliente) {
		boolean resultado = iCuentaDao.tieneCuentas(idCliente);
		
		return resultado;
	}
	
	@Override
	public int getTotalCuentasActivas() {
		int totalCuentas = iCuentaDao.getTotalCuentasActivas();
		
		return totalCuentas;
	}

}