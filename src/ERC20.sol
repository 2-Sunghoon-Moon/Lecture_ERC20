
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract ERC20  {
    mapping(address => uint256) private balances;
    mapping(address => mapping(address => uint256)) private allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;
    uint8 private _decimals;


    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);


    constructor() {
        _name = "DREAM";
        _symbol = "DRM";
        _decimals = 18;
        _totalSupply = 0;

        _mint(msg.sender, 100 ether);
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }


    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address _owner) public view returns (uint256) {
        return balances[_owner];
    }


    function transfer(address _to, uint256 _value) external returns (bool success) {
        require(_to != address(0), "transfer to the zero address"); // 제로 어드레스 검증
        require(balances[msg.sender] >= _value, "2");


        unchecked {
            balances[msg.sender] -= _value;
            balances[_to] += _value;
        }
 

        emit Transfer(msg.sender, _to, _value);
    }


    function approve(address _spender, uint256 _value) public returns (bool success) {
        require(_spender!= address(0), "approve to the zero address"); // 제로 어드레스 검증

        allowances[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
    }

    function allowance(address _owner, address _spender) public view returns (uint256 remainig) {
        return allowances[_owner][_spender];
    }

    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success) {
        
        // 허용된 토큰의 개수 검증
        require(allowances[_from][_to] >= _value, "allowed exceed");
        require(balances[_from] >= _value);

        // 허용된 토큰 감소
        allowances[_from][_to] -= _value;

        // 실제 잔고 변경
        balances[_from] -= _value;
        balances[_to] += _value;


        emit Transfer(_from, _to, _value);
    }


    function _mint(address _owner, uint256 _value) internal {
        require(_owner != address(0));

        _totalSupply += _value;

        unchecked {
            balances[_owner] += _value;
        }

        emit Transfer(address(0), _owner, _value);
    }


    function _burn(address _owner, uint256 _value) internal {
        require(_owner != address(0));
        require(balances[_owner] >= _value);

        unchecked {
            balances[_owner] -= _value;
            _totalSupply -= _value;
        }

        emit Transfer(_owner, address(0), _value);
    }
}
