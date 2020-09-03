	//
// Copyright (C) 2013-2018 University of Amsterdam
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as
// published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public
// License along with this program.  If not, see
// <http://www.gnu.org/licenses/>.
//
import QtQuick 2.8
import QtQuick.Layouts 1.3
import JASP.Controls 1.0
import JASP.Widgets 1.0
import JASP.Theme 1.0

Form {
	columns: 1
	IntegerField 
	{ 
		name: "n"; 
		label: qsTr("The number of players");
		defaultValue: 4 
		fieldWidth: 50 
	}


	TextField 
	{ 
		name: "k"; 
		label: qsTr("The number of points for each player when interrupted (comma delimited)"); 
		fieldWidth: 50
		value: "1,1,1,1"
		
		
		
	}

	IntegerField  
	{ 
		name: "t"; 
		label: qsTr("The number of points required to win the game"); 
		fieldWidth: 50
		defaultValue: 2 
	}

	TextField 
	{ 
		name: "p"; 
		label: qsTr("For every play, the probability that each player wins the point (comma delimited)"); 
		fieldWidth: 150
		value: "0.25,0.25,0.25,0.25"
		  
	}
	IntegerField   
	{ 
		name: "s"; 
		label: qsTr("The number of simulated games"); 
		fieldWidth: 50
		defaultValue: 500  
	}

	CheckBox 
	{ 
		name: "check"; 
		label: qsTr("95% credible interval (highest posterior density)"); 
		checked: true 
	}

}