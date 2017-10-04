//
//  Pipeline.swift
//  Pipeline
//
//  Created by Patrick Goley on 5/21/16.
//

import Foundation

/*
 An empty type that is returned once a Pipeline has been fully
 constructed. This means the Pipeline begins with a ConsumableType
 and ends with a ConsumerType, which disallows any futher composition.
 The creator of the Pipeline should retain it as long as it needs to 
 function.
*/

open class Pipeline { }

