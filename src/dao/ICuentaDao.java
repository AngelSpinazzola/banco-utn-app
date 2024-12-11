package dao;

import java.math.BigDecimal;
import java.util.ArrayList;
import entidad.Cuenta;

public interface ICuentaDao {
	public ArrayList<Cuenta> getCuentasDelCliente(int idCliente);
	public int agregarCuenta(int idCliente, int idTipoCuenta);
	public boolean modificarSaldo(int idCuenta, BigDecimal saldo);
	public int eliminarCuenta(int idCuenta);
	public BigDecimal getSaldoCuentaCliente(int idCuenta);
	public boolean validarSaldo(BigDecimal monto, String cbuOrigen);
	public boolean validarCuentaDestino(String cbuDestino);
	public boolean transferir(String cbuOrigen, String cbuDestino, String _monto);
}