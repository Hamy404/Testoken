pragma solidity ^0.8.0;
//padrão ERC-20
interface ERC20{

    //Suprimento total de tokens
    function totalSupply() external view returns(uint256);
    //Saldo de balanço de determinado endereço
    function balanceOf(address account) external view returns (uint256);
    //Disponibilização de saldo conjuntamente a outra conta
    function allowance(address owner, address spender) external view returns (uint256);

   
    //Envio de tokens
    function transfer(address recipient, uint256 amount) external returns (bool);
    //Aprovar o saldo gasto por determinada conta após o envio de tokens
    function approve(address spender, uint256 amount) external returns (bool);
    //Gastar certa quantia em nome do owner  
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    //Avisos de ativação para a transferência
    event Transfer(address indexed from, address indexed to, uint256 value);
    //Avisos de ativação para a aprovação
    event Approval(address indexed owner, address indexed spender, uint256);

}

contract TesToken is ERC20{
    //Nome da moeda
    string public constant name = "Test Token";
    //Símbolo do nome
    string public constant symbol = "Test";
    //número de casas decimais - 18 número contínuo
    uint8 public constant decimals = 18;
    ////Mostrar saldo
    mapping (address => uint256) balances;
    ////Mostrar histórico de transferências
    mapping(address => mapping(address=>uint256)) allowed;
    //Suprimento total
    uint256 totalSupply_ = 10 ether;
    
    constructor(){
        ////Sender é o owner ou endereço que publicou o contrato 
        balances[msg.sender] = totalSupply_;
    }
    //Mostrar saldo total public
    function totalSupply() public override view returns (uint256) {
        return totalSupply_;
    }
    //Mostrar saldo de endereço do token owner
    function balanceOf(address tokenOwner) public override view returns (uint256){
        return balances[tokenOwner];
    }
    ////Transferência de tokens
    function transfer(address receiver, uint256 numTokens) public override returns (bool) {
        require(numTokens <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender]-numTokens;
        balances[receiver] = balances[receiver]+numTokens;
        emit Transfer(msg.sender, receiver, numTokens);
        return true;
    }
    ////Delegação de tokens para uso de X endereço
    function approve(address delegate, uint256 numTokens) public override returns (bool) {
        allowed[msg.sender][delegate] = numTokens;
        emit Approval(msg.sender, delegate, numTokens);
        return true;
    }
    //Mostrar quantos tokens foram delegados ao endereço X
    function allowance(address owner, address delegate) public override view returns (uint) {
        return allowed[owner][delegate];
    }
    ////Debitar tokens do owner para endereço X 
    function transferFrom(address owner, address buyer, uint256 numTokens) public override returns (bool) {
        require(numTokens <= balances[owner]);
        require(numTokens <= allowed[owner][msg.sender]);

        balances[owner] = balances[owner]-numTokens;
        allowed[owner][msg.sender] = allowed[owner][msg.sender]-numTokens;
        balances[buyer] = balances[buyer]+numTokens;
        emit Transfer(owner, buyer, numTokens);
        return true;
    }

}