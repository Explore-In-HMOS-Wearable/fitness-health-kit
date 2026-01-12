export interface TokenResponse {
  accessToken: string;
  expiresIn: number;
  idToken?: string;
  refreshToken: string;
  scope: string;
  tokenType: string;
}