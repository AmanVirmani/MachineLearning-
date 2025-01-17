function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%
K= eye(num_labels);
Y= K(y,:);     %5000x10
a1= [ones(m,1) X];%5000x401
t1=Theta1(:,2:end); t2= Theta2(:,2:end);
%t1(:,1)= 0; t2(:,1)= 0;
reg= sumsqr(t1)+ sumsqr(t2); 
a2= sigmoid(a1*Theta1'); z3= [ones(size(a2,1),1) a2];  %5000x26
a2= z3*Theta2';       %5000x10
h= sigmoid(a2);       %5000x10
%[x, p] = max(h, [], 2);    % p is 5000x1
cospos= -(Y).*(log(h));    % 5000x10
cosnos= -(1-Y).*(log(1-h)); %5000x10
J= (1/m)*(sum(cospos + cosnos)); J= sum(J);
J= J+ (lambda/(2*m))*(reg);
delta1= zeros(size(Theta1));
delta2= zeros(size(Theta2));
for t=1:m
    a1= [1 ;X(t,:)'];   %401x1 
    z2= Theta1*a1; %25x1
    a2= [1; sigmoid(z2)]; %26x1
    z3= Theta2*a2;   %10x1
    a3= sigmoid(z3);   %10x1
    yt= Y(t,:)';   %10x1
    d3= a3-yt;    %10x1
    d2= (Theta2(:,2:end)'*d3).*sigmoidGradient(z2);  %25x1
    delta2= delta2+ d3*a2';    %10x26
    delta1= delta1+ d2*a1';    %25x401
    T2= Theta2; T2(:,1)=0;
    T1= Theta1; T1(:,1)=0;
    Theta2_grad= (1/m)*(delta2 + lambda*T2);
    Theta1_grad= (1/m)*(delta1 + lambda*T1);

















% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
