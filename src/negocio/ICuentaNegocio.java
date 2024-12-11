package negocio;

import java.math.BigDecimal;
import java.util.ArrayList;
import entidad.Cuenta;

public interface ICuentaNegocio {
	public ArrayList<Cuenta> getCuentasDelCliente(int idCliente);
	public int agregarCuenta(int idCliente, int idTipoCuenta);
	public boolean modificarSaldo(int idCuenta, BigDecimal saldoNuevo);
	public int eliminarCuenta(int idCuenta);
	public int validarTransferencia(String cbuOrigen, String cbuDestino, String monto);
	public boolean validarMonto(String monto);
	public boolean validarSaldo(BigDecimal monto, String cbuOrigen);
	public boolean validarCuentaDestino(String cbuDestino);
	public boolean realizarTransferencia(String cbuOrigen, String cbuDestino, String monto);
}	